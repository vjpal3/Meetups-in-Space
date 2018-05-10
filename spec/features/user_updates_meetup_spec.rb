require 'spec_helper'

feature 'user updates the meetup' do
  # As a meetup creator
  # I want to change my meetup's details
  # So the meetup has up-to-date details
  #
  # Acceptance Criteria:
  #
  # * If I am signed in and I created the meetup,
  #   there should be a link from the meetup's show page that takes you
  #   to the meetup's edit page. On this page there is a form to edit
  #   the meetup, and it is pre-filled with the meetup's details.
  # * I must be signed and the meetup's creator, and I must supply
  #   a name, location, and description.
  # * If the form submission is successful, I should be brought
  #   to the meetup's show page, and I should see a message
  #   that lets me know that the meetup has been successfully updated.
  # * If the form submission is unsuccessful, I should remain on the
  #   meetup's edit page, and I should see error messages
  #   explaining why the form submission was unsuccessful. The form should be
  #   pre-filled with the values that were provided when the form was submitted.

  let(:user1) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let(:hiking) do
    Meetup.create(
      title: 'Hiking and Adventures', creator_id: "#{user1.id}",
      description: 'An early example of an interest in hiking in the United States, is Abel Crawford and his son Ethan clearing of a trail to the summit of Mount Washington, New Hampshire in 1819.',
      address: '123 Apple St.', city: 'Providence',
      state: 'RI', zip: '02906'
    )
  end

  scenario 'user successfully updates the meetup' do
    visit '/'
    sign_in_as user1
    hiking

    visit '/meetups'
    find_link("#{hiking.title}").click
    find_button('Update this Meetup').click
    expect(page).to have_field('Title', with: "#{hiking.title}")

    first('input#creator_id', visible: false).set("#{user1.id}")
    fill_in "Title", with: "Food and Fun"
    fill_in "Category", with: "Food"
    fill_in "Description", with: "Come, explore the art of food"
    fill_in "Location", with: "The Greater Boston"
    fill_in "Address", with: "123 Boston St."
    fill_in "City", with: "Boston"
    fill_in "State", with: "MA"
    fill_in "Zip", with: "02314"

    click_button "Update Meetup"
    expect(page).to have_content "You have successfully updated the meetup"
    expect(page).to have_content("Food and Fun")
  end

  scenario 'user fails to update the meetup' do
    visit '/'
    sign_in_as user1
    hiking

    visit '/meetups'
    find_link("#{hiking.title}").click
    find_button('Update this Meetup').click
    fill_in "Title", with: ""
    fill_in "Category", with: "Food"
    fill_in "description", with: ""
    fill_in "Address", with: ""
    fill_in "State", with: ""
    click_button "Update Meetup"

    expect(page).to have_content("Update failed")
    expect(page).to have_content "Update Meetup information"
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Address can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("State can't be blank")
    expect(page).to have_field('Category', with: "Food")
    expect(page).to have_field('City', with: "Providence")
  end

  scenario 'unauthorized user cannot update meetup' do
    visit '/'
    sign_in_as user1
    hiking
    click_link "Sign Out"
    visit '/meetups'
    find_link("#{hiking.title}").click
    expect(page).to_not have_button('Update this Meetup')
  end

end
