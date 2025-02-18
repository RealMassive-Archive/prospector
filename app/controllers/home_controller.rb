class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:please_login, :map]


  def please_login
  end

  def jobboard
    @read_signage_jobs_count = Nugget.read_signage_jobs.count
    @review_signage_jobs_count = Nugget.review_signage_jobs.count
    @check_signage_duplicate_count = Nugget.dedupe_jobs.count
    @ready_to_contact_broker_count = Nugget.contact_broker_jobs.count
    @parse_info_from_broker_emails_jobs_count = BrokerEmail.not_parsed.count
    @listing_jobs = ListingNugget.listing_nuggets_of_parsed_broker_emails.count
  end

  def map
    @nuggets = Nugget.where("latitude IS NOT NULL")
  end

  def dashboard
    @nuggets = Nugget.all
    @initial_nuggets = Nugget.initial
    @signage_read_nuggets = Nugget.signage_read
    @signage_reviewed_nuggets = Nugget.signage_reviewed
    @no_gps_nuggets = Nugget.no_gps
    @blurry_nuggets = Nugget.blurry
    @inappropriate_nuggets = Nugget.inappropriate
    #@needs_rotation_nuggets = Nugget.needs_rotation
    @rejected_nuggets = Nugget.signage_rejected
    @ready_to_contact_broker_nuggets = Nugget.ready_to_contact_broker
    @awaiting_broker_response_nuggets = Nugget.awaiting_broker_response
    @dedupe_jobs = Nugget.dedupe_jobs
    @parse_info_from_broker_emails = Nugget.parse_info_from_broker_emails_jobs

    #broker emails
    @broker_emails = BrokerEmail.all
    @spam_broker_emails = BrokerEmail.spam
    @need_supervisor_review = BrokerEmail.need_supervisor_review
    @parsed_broker_emails = BrokerEmail.parsed
    @need_parsing_broker_emails = BrokerEmail.not_parsed
  end

end
