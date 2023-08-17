# frozen_string_literal: true

RSpec.describe DiscourseActivityPub::AP::FollowersController do
  let!(:actor) { Fabricate(:discourse_activity_pub_actor_group) }
  let!(:follower1) { Fabricate(:discourse_activity_pub_actor_person, created_at: (DateTime.now - 1)) }
  let!(:follow1) { Fabricate(:discourse_activity_pub_follow, follower: follower1, followed: actor) }
  let!(:follower2) { Fabricate(:discourse_activity_pub_actor_person, created_at: (DateTime.now - 2)) }
  let!(:follow2) { Fabricate(:discourse_activity_pub_follow, follower: follower2, followed: actor) }
  let!(:follower3) { Fabricate(:discourse_activity_pub_actor_person, created_at: DateTime.now) }
  let!(:follow3) { Fabricate(:discourse_activity_pub_follow, follower: follower3, followed: actor) }

  it { expect(described_class).to be < DiscourseActivityPub::AP::ActorsController }

  before do
    SiteSetting.activity_pub_require_signed_requests = false
  end

  describe "#index" do
    before do
      toggle_activity_pub(actor.model)
    end

    it "returns an ordered collection of the actors followers" do
      get_followers(actor)
      expect(response.status).to eq(200)
      expect(response.parsed_body['totalItems']).to eq(3)
      expect(response.parsed_body['orderedItems'][0]['id']).to eq(follower3.ap_id)
      expect(response.parsed_body['orderedItems'][1]['id']).to eq(follower1.ap_id)
      expect(response.parsed_body['orderedItems'][2]['id']).to eq(follower2.ap_id)
    end
  end
end
