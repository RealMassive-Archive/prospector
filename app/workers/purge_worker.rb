class PurgeWorker
  @queue = :purge_queue
  def self.perform
    # Doesn't need an ID. We're just going to nuke the
    # whole friggin' db from orbit.

    # Set the tables to purge.
    [BrokerCall, BrokerEmail, BrokerEmailAttachment, Duplicate,
     Listing, ListingAttachment, ListingNugget, Message, Nugget, NuggetSignage,
     NuggetStateTransition].each { |m| m.destroy_all }
  end
end