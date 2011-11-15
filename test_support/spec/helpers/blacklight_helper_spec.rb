require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlacklightHelper do
  it "should include HydraHelper" do
    BlacklightHelper.included_modules.should include(HydraHelper)
  end
  
  describe "Application Name Sanity Check" do
    it "should have the application correct name" do 
      helper.application_name.should == "A Hydra Head"
    end 
  end
  
  describe "Overridden blacklight methods" do
    describe "document_partial_name" do
      it "Should lop off everything before the first colin after the slash" do
        helper.document_partial_name('has_model_s' => ["info:fedora/afmodel:Presentation"]).should == "presentations"
        helper.document_partial_name('has_model_s' => ["info:fedora/hull-cModel:genericContent"]).should == "generic_contents" 
      end
    end
    describe "render_head_content" do
      before (:each) do
        helper.expects(:content_for).with(:head).returns("My added content")
        head_stuff = ["Something extra", "Stuff for unapi-server"]
        helper.expects(:extra_head_content).twice().returns(head_stuff)
      end
      it "adds the content of content_for(:head) to the output" do
        helper.render_head_content.should == "Something extraMy added content"
      end
    end
    describe "link_to_document" do
      before(:each)do
        @mock_doc = mock('mock doc')
        @mock_doc.expects(:[]).with(:id).returns("123456")
      end
      it "passes on the title attribute to the link_to_with_data method" do
        helper.link_to_document(@mock_doc,:label=>"Some crazy long label...",:title=>"Some crazy longer label").should match(/title=\"Some crazy longer label\"/)
      end
      it "doesn't add an erroneous title attribute if one isn't provided" do
        helper.link_to_document(@mock_doc,:label=>"Some crazy long label...").should_not match(/title=/)
      end
    end
    
    describe "link back to catalog" do
      it "should return the view parameter in the link back to catalog method if there is one in the users previous search session" do
        session[:search] = {:view=>"list"}
        helper.link_back_to_catalog.should match(/\?view=list/)
      end
      it "should not return the view parameter if it wasn't provided" do
        session[:search] = {}
        helper.link_back_to_catalog.should_not match(/\?view=/)
      end
    end
  end
  
  describe "SALT methods" do
    describe "get_data_with_linked_label" do
      before(:each) do
        @doc = {"field"=>["Item1","Item2","Item3"]}
      end
      it "should return a string representing the collection of items with the suplied delimiter" do
        helper.get_data_with_linked_label(@doc,"Items","field",{:delimiter=>", "}).should match(/, /)
      end
      it "should return a string representing the collection of items with the default <br/> delimiter" do
        helper.get_data_with_linked_label(@doc,"Items","field").should match(/<br\/>/)
      end
    end
  end
  
end
