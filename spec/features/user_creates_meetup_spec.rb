require "spec_helper"

feature "user creates a new meetup" do
  # As a user
  # I want to create a meetup
  # So that I can gather a group of people to do an activity
  #
  # Acceptance Criteria:
  # * There should be a link from the meetups index page that takes you to the meetups new page. On this page there is a form to create a new meetup.
  # * I must be signed in, and I must supply a name, location, and description.
  # * If the form submission is successful, I should be brought to the meetup's show page, and I should see a message that lets me know that I have created a meetup successfully.
  # * If the form submission is unsuccessful, I should remain on the meetups new page,
  # and I should see error messages explaining why the form submission was unsuccessful.
  # The form should be pre-filled with the values that were provided when the form was submitted.

  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "user successfully creates a new meetup" do
    visit '/'
    sign_in_as user
    click_link('Create a new Meetup!')

    expect(page).to have_content("Create a new Meetup")
    first('input#creator_id', visible: false).set("#{user.id}")
    fill_in "Title", with: "Food and Fun"
    fill_in "Category", with: "Food"
    fill_in "Description", with: "Come, explore the art of food"
    fill_in "Location", with: "The Greater Boston"
    fill_in "Address", with: "123 Boston St."
    fill_in "City", with: "Boston"
    fill_in "State", with: "MA"
    fill_in "Zip", with: "02314"

    click_button "Create New Meetup"
    expect(page).to have_content "You have successfully created a meetup"
    expect(page).to have_content("Food and Fun")
    # expect(page).to have_current_path("/meetups")
  end

  scenario "unauthenticated user needs to sign in to create a new meetup" do
    visit '/'

    click_link('Create a new Meetup!')
    # expect(flash[:notice]).to be_present  -- Doesn't work
    expect(page).to have_link("Sign In")
    expect(page).to have_link('Create a new Meetup!')
  end

  scenario "Fails to create a new meetup" do
    visit '/'
    sign_in_as user
    click_link('Create a new Meetup!')

    fill_in "Title", with: "Art of Origami"
    first('input#creator_id', visible: false).set("#{user.id}")
    click_button "Create New Meetup"

    expect(page).to have_content("Failed to create a new meetup")
    # expect(page).to have_content("Art of Origami")
    expect(page).to have_field('Title', with: 'Art of Origami')
    expect(page).to have_content("Address can't be blank")
    expect(page).to have_content("City can't be blank")
    expect(page).to have_content("Zip can't be blank")

  end
end
