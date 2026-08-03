require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render body: nil
    end

    def missing_template
      render "missing_template"
    end
  end

  before do
    routes.draw do
      get "missing_template" => "anonymous#missing_template"
    end
  end

  describe "#append_info_to_payload" do
    let(:payload) { {} }
    let(:request) { instance_double(ActionDispatch::Request, host: "localhost", request_id: "abc123", env: env_variable) }
    let(:env_variable) { { "HTTP_X_FORWARDED_FOR" => "192.168.1.1" } }

    before do
      allow(controller).to receive(:request).and_return(request)
      controller.append_info_to_payload(payload)
    end

    it "appends request_host to the payload" do
      expect(payload[:request_host]).to eq "localhost"
    end

    it "appends request_id to the payload" do
      expect(payload[:request_id]).to eq "abc123"
    end

    it "appends user_ip to the payload" do
      expect(payload[:user_ip]).to eq "192.168.1.1"
    end
  end

  describe "#user_ip" do
    context "when HTTP_X_FORWARDED_FOR is an IPV4" do
      it "returns IPV4" do
        expect(controller.user_ip("192.168.1.1")).to eq "192.168.1.1"
      end
    end

    context "when HTTP_X_FORWARDED_FOR is an IPV6" do
      it "returns IPV6" do
        expect(controller.user_ip("2001:0db8:12f0:0000:0000:0000:0000:0001")).to eq "2001:0db8:12f0:0000:0000:0000:0000:0001"
      end
    end

    context "when HTTP_X_FORWARDED_FOR is empty" do
      it "returns nil" do
        expect(controller.user_ip("")).to be_nil
      end
    end
  end

  describe "missing template" do
    it "returns 406 when request format is not HTML" do
      get :missing_template, format: :json
      expect(response).to have_http_status(:not_acceptable)
    end

    it "raises the error when the request format is HTML" do
      expect { get :missing_template, format: :html }.to raise_error(ActionView::MissingTemplate)
    end
  end
end
