require 'spec_helper'

feature 'user cancels the meetup' do
  # As a meetup creator
  # I want to cancel my meetup
  # So nobody comes to a meetup that is not taking place
  #
  # Acceptance Criteria:
  #
  # * If I am signed in and I created the meetup, there should be a delete button
  #   on the meetup's show page.
  # * If I click on the delete button, the meetup should be deleted
  #   and I should be redirected to the meetups index page.
  #   Also, all of the meetup's memberships should be deleted as well.

  let(:user1) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let(:user2) do
    User.create(
      provider: "github",
      uid: "2",
      username: "jarlax2",
      email: "jarlax2@launchacademy.com",
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

  scenario 'meetup creator successfully cancels the meetup' do
    visit '/'
    sign_in_as user1
    hiking

    visit '/meetups'
    find_link("#{hiking.title}").click
    find_button('Delete this Meetup').click
    expect(page).to_not have_link("#{hiking.title}")
  end

  scenario 'unauthorized user cannot cancel meetup' do
    visit '/'
    sign_in_as user1
    hiking
    click_link "Sign Out"
    sign_in_as user2
    visit '/meetups'
    find_link("#{hiking.title}").click
    expect(page).to_not have_button('Delete this Meetup')
  end

end
