require 'spec_helper'

feature 'user leaves the meetup' do
  # As a meetup member
  # I want to leave a meetup
  # So that I'm no longer listed as a member of the meetup
  # Acceptance Criteria:
  #
  # * On a meetup's show page, there should be a button to leave the meetup
  #   if I am signed in and I am a member of the meetup.
  # * If I click the button, I should see a message that says that
  #   I have left the meetup and I should be removed from the meetup's members list.

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

  scenario 'meetup member successfully leaves the meetup' do
    visit '/'
    sign_in_as user1
    hiking
    click_link "Sign Out"
    sign_in_as user2
    visit '/meetups'

    find_link("#{hiking.title}").click
    find_button('Join Meetup').click
    find_button('Leave Meetup').click

    expect(page).to have_content(hiking.title)
    expect(page).to_not have_content(user2.avatar_url)
    expect(page).to have_content "You have left the meetup"
    #expect(page).to have_xpath('//img')
    expect(page).to have_content(hiking.address)

  end

  scenario 'unauthenticated user cannot leave the meetup' do
    visit '/'
    sign_in_as user1
    hiking
    click_link "Sign Out"

    visit '/meetups'
    find_link("#{hiking.title}").click
    
    expect(page).to_not have_button('Leave Meetup')

  end


end
