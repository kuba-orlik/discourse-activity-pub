# frozen_string_literal: true

RSpec.describe TopicsController do
  ADDITIONAL_QUERY_LIMIT = 12

  describe "#show" do
    fab!(:category)
    fab!(:topic) { Fabricate(:topic, category: category) }

    def fab_ap_objects
      collection = Fabricate(:discourse_activity_pub_ordered_collection, model: topic)
      posts = []
      20.times do
        post = Fabricate(:post, topic: topic)
        posts << post
        note =
          Fabricate(:discourse_activity_pub_object_note, model: post, collection_id: collection.id)
        Fabricate(:discourse_activity_pub_activity_create, object: note)
      end
      posts
    end

    def track_topic_show_queries
      track_sql_queries do
        get "/t/#{topic.id}.json"
        expect(response.status).to eq(200)
      end
    end

    context "without a logged in user" do
      context "without activity pub enabled" do
        it "works" do
          get "/t/#{topic.id}.json"
          expect(response.status).to eq(200)
        end
      end

      context "with activity pub first_post enabled" do
        before { fab_ap_objects }

        it "does not increase the number of queries beyond the limit" do
          SiteSetting.activity_pub_enabled = false

          get "/t/#{topic.id}.json"
          expect(response.status).to eq(200)

          disabled_queries = track_topic_show_queries

          SiteSetting.activity_pub_enabled = true
          toggle_activity_pub(category, publication_type: "first_post")

          enabled_queries = track_topic_show_queries
          expect(enabled_queries.count).to be <= (disabled_queries.count + ADDITIONAL_QUERY_LIMIT)
        end
      end

      context "with activity pub full_topic enabled" do
        before { fab_ap_objects }

        it "does not increase the number of queries beyond the limit" do
          SiteSetting.activity_pub_enabled = false

          get "/t/#{topic.id}.json"
          expect(response.status).to eq(200)

          disabled_queries = track_topic_show_queries

          SiteSetting.activity_pub_enabled = true
          toggle_activity_pub(category, publication_type: "full_topic")

          enabled_queries = track_topic_show_queries
          expect(enabled_queries.count).to be <= (disabled_queries.count + ADDITIONAL_QUERY_LIMIT)
        end
      end
    end

    context "with a logged in user" do
      let!(:user) { Fabricate(:user) }

      before { sign_in(user) }

      context "without activity pub enabled" do
        it "works" do
          get "/t/#{topic.id}.json"
          expect(response.status).to eq(200)
        end
      end

      context "with activity pub first_post enabled" do
        before { fab_ap_objects }

        it "does not increase the number of queries beyond the limit" do
          SiteSetting.activity_pub_enabled = false

          get "/t/#{topic.id}.json"
          expect(response.status).to eq(200)

          disabled_queries = track_topic_show_queries

          SiteSetting.activity_pub_enabled = true
          toggle_activity_pub(category, publication_type: "first_post")

          enabled_queries = track_topic_show_queries

          expect(enabled_queries.count).to be <= (disabled_queries.count + ADDITIONAL_QUERY_LIMIT)
        end
      end

      context "with activity pub full_topic enabled" do
        before { fab_ap_objects }

        it "does not increase the number of queries beyond the limit" do
          SiteSetting.activity_pub_enabled = false

          get "/t/#{topic.id}.json"
          expect(response.status).to eq(200)

          disabled_queries = track_topic_show_queries

          SiteSetting.activity_pub_enabled = true
          toggle_activity_pub(category, publication_type: "full_topic")

          enabled_queries = track_topic_show_queries
          expect(enabled_queries.count).to be <= (disabled_queries.count + ADDITIONAL_QUERY_LIMIT)
        end
      end
    end
  end
end
