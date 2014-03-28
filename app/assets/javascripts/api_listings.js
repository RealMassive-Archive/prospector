$(document).ready(function() {
  // Declare the Building object
  var building = new Object();

  // Declare a spinner object to be used with sonic.js.
  // Shamelessly ripped from sonic.js examples
  // https://github.com/padolsey/sonic.js
  var spinner = {
    width: 100,
    height: 100,

    stepsPerFrame: 1,
    trailLength: 1,
    pointDistance: .025,

    strokeColor: '#1a4666',

    fps: 30,

    setup: function() {
      this._.lineWidth = 2;
    },
    step: function(point, index) {

      var cx = this.padding + 50,
        cy = this.padding + 50,
        _ = this._,
        angle = (Math.PI/180) * (point.progress * 360);

      this._.globalAlpha = Math.max(.5, this.alpha);

      _.beginPath();
      _.moveTo(point.x, point.y);
      _.lineTo(
        (Math.cos(angle) * 35) + cx,
        (Math.sin(angle) * 35) + cy
      );
      _.closePath();
      _.stroke();

      _.beginPath();
      _.moveTo(
        (Math.cos(-angle) * 32) + cx,
        (Math.sin(-angle) * 32) + cy
      );
      _.lineTo(
        (Math.cos(-angle) * 27) + cx,
        (Math.sin(-angle) * 27) + cy
      );
      _.closePath();
      _.stroke();

    },
    path: [
      ['arc', 50, 50, 40, 0, 360]
    ]
  };

  // Hide the error itself.
  function hide_error() {
    $('#error').hide();
  }

  // A function to show the error message and parse the template.
  function show_error(d) {
    // d is a "data" object from a jquery ajax call
    var tmp = Handlebars.compile($('#error').html());
    $('#error').html(tmp(d));
    hide_spinner();
    $('#error').show();
  }

  // Function to show the spinner.
  function show_spinner() {
    sp = $('#spinner');
    sp.css("text-align", "center");
    sp.show();
  }

  // Used to easily hide the spinner when needed
  function hide_spinner() {
    $('#spinner').hide();
  }

  // Start by creating a spinner, hiding all forms, then showing the first one.
  hide_error();
  s = new Sonic(spinner);
  $('#spinner').append(s.canvas);
  s.play();
  hide_all_forms();
  show_form('building_form');

  function hide_all_forms() {
    // Hide all forms, then show the building creation form.
    $('#building_forms form').hide();

    // Additionally, hide the spinner.
    hide_spinner();
  }

  function show_form(frm) {
    $('#building_forms #' + frm).show();
  }


  $('#building_form').show(); // start here

  // Handler for building "next" button.
  $('#building_form').submit(function(event) {
    // Wrap up form values into a building object.
    inputs = $('#building_form input[type=text]');
    for(i = 0; i < inputs.length; i++) {
      if(inputs[i].value.length < 1) {
        alert(inputs[i].id + " doesn't appear to be filled out correctly.");
        return false;
      }
      // Assign values to the appropriate properties of building.
      building[inputs[i].id] = inputs[i].value;
    }
    find_building(building); // trigger the find_building function below.
    return false; // don't submit form yet (preventDefault doesn't work here)
  });

  // Building search function.
  function find_building(bldg) {
    // bldg should contain our building object. Use that data to create
    // an ApiRequest object, then query the system every N seconds (3?)
    // to see if it's done yet.

    // Show the spinner and hide the forms.
    hide_all_forms();
    show_spinner();

    // Start by creating a params hash the server will like. Needs to be in the
    // format of:
    //
    // { model_type: building, run_method: search, run_args_hash: building_obj }
    var params = $.param({
      api_request: {
        model_type: "building",
        run_method: "search",
        run_args_hash: {street: building.street, city: building.city,
                        state: building.state, zipcode: building.zipcode}
      }
    })

    new_api_request = $.ajax({
      url: "/api_requests",
      type: "POST",
      data: params,
      dataType: "json"
    }).done(function(data) {
      console.log(data);
      waiting_screen("building_list", data.id);
    });
  }

  // Waiting screen function
  function waiting_screen(next_step, api_request_id) {
    var interv = window.setInterval(function() {
      status_check = $.ajax({
        url: '/api_requests/' + api_request_id,
        type: "GET",
        dataType: "json"
      }).done(function(data) {
        // Check for failure so we can bail out quickly.
        if(data.status && data.status == 'fail') {
          clearInterval(interv);
          show_error(data);
        }

        // If no failure, look for success so we can proceed. Otherwise the item
        // is trapped in limbo until the system returns a success or fail, or
        // the browser is closed.
        if(data.response_body && data.response_body.length > 0 && data.status && data.status == 'success') {
          // Success, we have data. Parse the json and show buildings.
          // Clear the interval to stop pinging the server.
          clearInterval(interv);

          switch(next_step) {
          case "building_list":
            show_building_options(JSON.parse(data.response_body).results);
            break;
          case "new_space_form":
            console.log(next_step);
            show_new_space_form(JSON.parse(data.response_body));
            break;
          default:
            show_building_options(JSON.parse(data.response_body).results);
          }
        }
      });
    }, 2000);
  }

  // Clicking the "back" button on the building list form should
  // hide all forms and show the building list form.
  // Need to use the $(document).on syntax here because $('#elem').click
  // only looks for elements that were on the screen when the page FIRST loaded.
  // Pseudo-answer from: http://stackoverflow.com/questions/19237235/jquery-button-click-event-not-firing
  $(document).on("click", "#btn_building_list_back", function() {
    hide_all_forms();
    show_form('building_form');
  });

  // Next step after clicking the next button on the building selection
  $('#building_list_form').submit(function(event) {
    event.preventDefault();

    val = $('#building_list_form input[name=api_uuid]:checked').val();
    if(val && val.length > 0) {
      // User selected an existing building.
      // Assign UUID to the building object and move on to showing the
      // space creation form.
debugger;
      building.key = val;
      show_new_space_form(building);
    }
    else {
      // User wants a new building so create it and get the ID.
      console.log(building);
      create_building(building);
    }


  });

  function create_building(bldg) {
    // Hide the forms and show the spinner
    hide_all_forms();
    show_spinner();

    // Submit the request to the API.
    var params = $.param({
      api_request: {
        model_type: "building",
        run_method: "api_create",
        run_args_hash: {title: bldg.name, street: bldg.street, city: bldg.city,
                        state: bldg.state, zipcode: bldg.zipcode}
      }
    })

    new_api_request = $.ajax({
      url: "/api_requests",
      type: "POST",
      data: params,
      dataType: "json"
    }).done(function(data) {
      console.log(data);
      waiting_screen("new_space_form", data.id);
    });
  }

  // Shows the choice of building options - pick one in the list, or
  // create a new one. Will assign the appropriate API UUID based on the "key"
  // ...erm...key in the JSON hash to the building object.
  function show_building_options(buildings) {
    // buildings should already be an array of JSON-parsed objects.
    // Parse the internal template with Handlebars.js (http://handlebarsjs.com/)
    // and show it.
    var tmp = Handlebars.compile($('#building_list_form').html());
    $('#building_list_form').html(tmp(buildings));

    // Hide the previous form
    hide_all_forms();
    hide_spinner();
    show_form('building_list_form');
  }

  // shows the new space form and sets the building's api_uuid based on the
  // return data from the app's API request object (response_body)
  function show_new_space_form(bldg) {
debugger;
    // Set the building's API uuid
    building.key = bldg.key; // key is provided from Electrick's API.
    building.title = bldg.name;
    building.address = {street: bldg.street, city: bldg.city, state: bldg.state,
                        zipcode: bldg.zipcode}; // Hash of options

    var tmp = Handlebars.compile($('#new_space_form').html());
    $('#new_space_form').html(tmp(building))
    hide_all_forms();
    hide_spinner();
    show_form('new_space_form');
  }

});
