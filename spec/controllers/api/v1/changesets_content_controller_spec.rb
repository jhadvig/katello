#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

require 'spec_helper.rb'

#def self.it_should_require_admin_for_actions(*actions)
#  actions.each do |action|
#    it "#{action} action should require admin" do
#      get action, :id => 1
#      response.should redirect_to(login_url)
#      flash[:error].should == "Unauthorized Access"
#    end
#  end
#end

describe Api::V1::ChangesetsContentController, :katello => true do
  include LoginHelperMethods
  include AuthorizationHelperMethods
  include OrchestrationHelper

  let(:changeset_id) { '1' }

  before(:each) do
    disable_product_orchestration
    disable_repo_orchestration
    disable_org_orchestration
    @org = Organization.create!(:name=>'test_organization', :label=> 'test_organization')
    @library    = @org.library
    @environment    = create_environment(:name => 'environment', :label => 'environment', :prior => @library, :organization=>@org)
    @library.stub(:successor).and_return(@environment)

    @view = @environment.content_views.first
    ContentView.stub(:find).and_return(@view)

    @cs = PromotionChangeset.create!(:name => "changeset", :environment => @environment)
    Changeset.stub(:find).and_return(@cs)

    @request.env["HTTP_ACCEPT"] = "application/json"
    login_user_api
  end

  let(:authorized_user) do
    user_with_permissions do |u|
      u.can(:manage_changesets, :environments, @environment.id, @organization)
      u.can(:promote, :content_views, @view.id, @organization)
    end
  end
  let(:unauthorized_user) do
    user_without_permissions
  end

  describe "add_content_view" do
    let(:action) { :add_content_view }
    let(:req) { post action, changeset_id: changeset_id, content_view_id: @view.id }
    it_should_behave_like "protected action"

    it "should add a content view" do
      @cs.should_receive(:add_content_view!).with(@view).and_return(@view)
      req
      response.should be_success
    end
  end

  describe "remove_content_view" do
    let(:action) { :remove_content_view }
    let(:req) { post action, changeset_id: changeset_id, id: @view.id }
    it_should_behave_like "protected action"

    it "should remove a content view" do
      @cs.should_receive(:remove_content_view!).with(@view).and_return(@view)
      req
      response.should be_success
    end
  end
end
