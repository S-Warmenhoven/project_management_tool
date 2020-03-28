require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

    def current_user
        @current_user ||= FactoryBot.create(:user)
    end

    def unauthorized_user
        @unauthorized_user ||= FactoryBot.create :user 
    end

    describe '#new' do
        context 'with no user signed in' do 
            it 'should redirect to session#new' do
                get :new 
                expect(response).to redirect_to(new_session_path)
            end 
            it 'sets a flash danger message' do 
                get :new
                expect(flash[:danger]).to be
            end
        end
        context 'with user signed in' do
            before do 
                session[:user_id] = current_user.id
            end
            it 'should render the new template' do
                # GIVEN
                # Defaults
                # WHEN 
                # Making a GET request to the new action 
                get(:new)
                # THEN
                # The `response` contains the rendered template of `new`
                #
                # The `response` object is available in any controller. It 
                # is similar to the `response` available in Express 
                # Middleware, however we rarely interact with it directly in 
                # Rails. RSpec makes it available when testing 
                # so that we can verify its contents. 
                
                # Here we verify with the `render_template` matcher that it 
                # contains the right rendered template. 
                expect(response).to(render_template(:new)) 
            end

            it 'should set an instance variable with a new project' do
                get(:new) 
                # Only available if we have added the 
                # gem 'rails-controller-testing
                
                expect(assigns(:project)).to(be_a_new(Project))
                # The above matcher will verify that the expected value 
                # is a new instance of the Project Class(/Model)
            end
        end
    end

    describe '#create' do
        
        def valid_request 
            # The post method below simulates an HTTP request to 
            # the create action of the ProjectsController using 
            # the POST verb. 

            # This effectively simulates a user filling out a new
            # form in the browser and pressing submit. 
            post(:create, params: { project: FactoryBot.attributes_for(:project)})
        end
        context 'with no user signed in' do 
            it 'should redirect to session#new' do
                valid_request 
                expect(response).to redirect_to(new_session_path)
            end 
            it 'sets a flash danger message' do 
                valid_request
                expect(flash[:danger]).to be
            end
        end
        context 'with user signed in' do
            # Use `before` to run a block of code before all tests 
            # inside of the block it is defined in. In this case, the
            # below block will run before the tests within this 
            # context 'with user signed in' block
            before do
                # @current_user = FactoryBot.create(:user)
                # To simulate signing in a user, set a `user_id`
                # in the session. RSpec makes a controller's session 
                # available inside your tests
                session[:user_id] = current_user.id
            end
            # `context` the functionally teh same as `describe`, 
            # but we generally use it to organize groups of 
            # branching code paths
            context 'with valid parameters' do

                it 'should create a new project in the db' do
                    count_before = Project.count
                    valid_request
                    count_after = Project.count 
                    expect(count_after).to eq(count_before + 1)
                end
                it 'should redirect to the show page of that project' do
                    valid_request
                    project = Project.last
                    expect(response).to(redirect_to(project_path(project)))
                end
                it 'associates the current_user to the created project' do
                    valid_request
                    project = Project.last
                    expect(project.user).to eq(current_user)
                end
            end

            context 'with invalid parameters' do
                def invalid_request 
                    post(:create, params: { project: FactoryBot.attributes_for(:project, title: nil)})
                end
                it 'should assign an invalid project as an instance variable' do 
                    invalid_request
                    expect(assigns(:project)).to be_a(Project)
                    expect(assigns(:project).valid?).to be(false)
                end
                it 'should render the new template' do 
                    invalid_request
                    expect(response).to(render_template(:new)) 
                end
                it 'should not create a project in the db' do 
                    count_before = Project.count
                    invalid_request
                    count_after = Project.count 
                    expect(count_after).to eq(count_before)
                end
            end
        end
    end

    describe '#show' do 
        it 'render the show template' do 
            # GIVEN 
            # A job post in the db 
            project = FactoryBot.create(:project)
            # WHEN 
            # A GET request is made to /projects/:id
            get(:show, params: {id: project.id})
            # THEN
            # The response contains the rendered show template
            expect(response).to render_template(:show)
        end
        it 'should set an instance variable project for the shown object' do 
            # GIVEN 
            # A job post in the db 
            project = FactoryBot.create(:project)
            # WHEN 
            # A GET request is made to /projects/:id
            get(:show, params: {id: project.id})
            expect(assigns(:project)).to eq(project)
        end
    end

    describe '#destroy' do
         context 'with no user signed in' do 
            before do 
                project = FactoryBot.create(:project)
                delete(:destroy, params: {id: project.id})
            end
            it 'should redirect to session#new' do
                expect(response).to redirect_to(new_session_path)
            end 
            it 'sets a flash danger message' do 
                expect(flash[:danger]).to be
            end
        end
        context 'with signed in user' do 
            before do 
                session[:user_id] = current_user.id
            end
            context 'as non-owner' do 
                it 'redirects to project show' do 
                    project = FactoryBot.create(:project)
                    delete(:destroy, params: {id: project.id})
                    expect(response).to redirect_to root_path
                end
                it 'sets a flash alert' do
                    project = FactoryBot.create(:project)
                    delete(:destroy, params: {id: project.id})
                    expect(flash[:alert]).to be
                end
                it 'does not remove a project' do
                    project = FactoryBot.create(:project)
                    delete(:destroy, params: {id: project.id})
                    expect(Project.find_by(id: project.id)).to eq(project)
                    #.find throws an exception if finding nil
                    #but .find_by will return nil
                end  
            end
            context 'as owner' do 
                it 'removes a project from the database' do 
                    project = FactoryBot.create(:project, user: current_user)
                    delete(:destroy, params: {id: project.id})
                    expect(Project.find_by(id: project.id)).to be(nil)
                end
                it 'redirects to the project index' do
                    project = FactoryBot.create(:project, user: current_user)
                    delete(:destroy, params: {id: project.id})
                    expect(response).to redirect_to projects_path
                end 
            end
        end
    end

    describe '#index' do

        before do
            get :index
        end

        it "renders the index template" do
            expect(response).to render_template(:index)
        end

        it "assigns an instance variable to all created projects (sorted by created_at)" do
            project_1 = FactoryBot.create(:project)
            project_2 = FactoryBot.create(:project)
            expect(assigns(:projects)).to eq([project_2, project_1])
        end
    end

    describe "#edit" do
        let!(:project) { FactoryBot.create :project, user: current_user }
        context "with no user signed in" do
            it "redirects to the sign in page" do
                get :edit, params: { id: project.id }
                expect(response).to redirect_to new_session_path
            end
        end
        
        context "with user signed in" do
            context "with authorized user" do
        
                before do
                    request.session[:user_id] = current_user.id
                    get :edit, params: { id: project.id }
                end
        
                it "renders the edit template" do
                    get :edit, params: { id: project.id }
                    expect(response).to render_template :edit
                end
        
                it "sets an instance variable based on the article id that is passed" do
                    get :edit, params: { id: project.id }
                    expect(assigns(:project)).to eq(project)
                end
            end
        
            context "with unauthorized user" do
        
                before do
                    request.session[:user_id] = unauthorized_user.id
                    get :edit, params: { id: project.id }
                end
        
                it "redirects to the root path" do
                  expect(response).to redirect_to root_path
                end
        
                it "sets a flash message" do
                  expect(flash[:alert]).to be
                end
            end
        end
    end
        
    describe "#update" do
        let!(:project) { FactoryBot.create :project, user: current_user }
        
        context "with valid parameters" do
            context "with user signed in" do

                context "with authorized user" do

                    before do
                      request.session[:user_id] = current_user.id
                    end

                    context 'with valid parameters' do
                        it "updates the project record with new attributes" do
                            new_description = "#{project.description} This should change!"
                            patch :update, params: {id: project.id, project: {description: new_description}}
                            expect(project.reload.description).to eq(new_description)
                        end
          
                        it "redirect to the news article show page" do
                            new_title = "#{project.title} plus changes!"
                            patch :update, params: {id: project.id, project: {title: new_title}}
                            expect(response).to redirect_to(project)
                        end
                    end
                
                    context 'with invalid parameters' do

                        def invalid_request
                            patch :update, params: {id: project.id, project: {title: nil}}
                        end
                    end
                end

                context "with unauthorized user" do

                    before do
                        request.session[:user_id] = unauthorized_user.id
                        patch :update, params: {id: project.id, project: {title: "New title that shouldn't be updated anyways"}}
                    end
            
                    it "redirects to the project path" do
                        expect(response).to redirect_to root_path
                    end
            
                    it "sets a flash message" do
                        expect(flash[:alert]).to be
                    end
                end
            end
        end
    end
end
