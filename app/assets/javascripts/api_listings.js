$(document).ready(function() {
  // Declare the Building object
  var building = new Object();

  // Hide all forms, then show the building creation form.
  $('form').hide();
  $('#building_form').show(); // start here

  // Handler for building "next" button.
  $('#building_form #btn_next').click(function(event) {
    event.preventDefault(); // don't submit form yet

    // Wrap up form values into a building object.
    inputs = $('#building_form input[type=text]');
    for(i = 0; i < inputs.length; i++) {
      if(inputs[i].value.length < 1) {
        alert(inputs[i].id + " doesn't appear to be filled out correctly.");
        break;
      }
      // Assign values to the appropriate properties of building.
      building[inputs[i].id] = inputs[i].value;
    }
    console.log(building);
    find_building(building); // trigger the find_building function below.
  });

  // Building search function.
  function find_building(bldg) {
    // bldg should contain our building object. Use that data to create
    // an ApiRequest object, then query the system every N seconds (3?)
    // to see if it's done yet.

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
      waiting_screen("building", data.id);
    });
  }

  // Waiting screen function
  function waiting_screen(model_type, api_request_id) {
    // TODO: spinner
    var interv = window.setInterval(function() {
      console.log("doing a ping of " + model_type + " " + api_request_id);
      console.log(interv);
      status_check = $.ajax({
        url: '/api_requests/' + api_request_id,
        type: "GET",
        dataType: "json"
      }).done(function(data) {
        // Check for failure so we can bail out quickly.
        if(data.status && data.status == 'fail') {
          console.log("IT ASPLODED!");
          console.log(data);
          clearInterval(interv);
          alert("Internal failure. Talk to management about this listing.")
        }

        // If no failure, look for success so we can proceed. Otherwise the item
        // is trapped in limbo until the system returns a success or fail, or
        // the browser is closed.
        if(data.response_body && data.response_body.length > 0 && data.status && data.status == 'success') {
          // Success, we have data. Parse the json and show buildings.
          console.log(JSON.parse(data.response_body));
          // Clear the interval to stop pinging the server.
          console.log(interv);
          clearInterval(interv);
        }
      });
    }, 3000);
  }

});
