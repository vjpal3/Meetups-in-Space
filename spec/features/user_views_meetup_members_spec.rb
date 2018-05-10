require 'spec_helper'

feature 'user views list of members joining the meetup' do


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

  let(:participant) do
    MeetupParticipant.create(
      meetup_id: "#{hiking.id}", user_id: "#{user1.id}"
    )
  end

  scenario 'view list of members' do
    # As a user
    # I want to see who has already joined a meetup
    # So that I can see if any of my friends have joined
    # Acceptance Criteria:
    # * On a meetup's show page, I should see a list of the members that have joined the meetup.
    # * I should see each member's avatar and username.

    visit '/'
    sign_in_as user1
    hiking
    participant

    click_link "Sign Out"

    visit '/meetups'
    expect(page).to have_link('Hiking and Adventures')
    click_link('Hiking and Adventures')
    expect(page).to have_content(hiking.title)
    expect(page).to have_content("#{user1.username}")
    expect(page).to have_xpath('//img')
    # expect(page).to have_xpath('//img[contains(@src,"#{user1.avatar_url}"]')
  end

  scenario "authenticated user joins the meetup" do
    # As a user
    # I want to join a meetup
    # So that I can partake in this meetup
    #
    # * On a meetup's show page, there should be a button to join the meetup
      #if I am not signed in or if I am signed in, but I am not a member of the meetup.
    # * If I am signed in and I click the button,
      #I should see a message that says that I have joined the meetup and I should be added to the meetup's members list.


    visit '/'
    sign_in_as user1
    hiking
    participant
    click_link "Sign Out"
    sign_in_as user2

    visit '/meetups'
    expect(page).to have_link('Hiking and Adventures')
    click_link('Hiking and Adventures')
    expect(page).to have_content(hiking.title)
    find_button('Join Meetup').click
    expect(page).to have_content(user2.username)
    expect(page).to have_xpath('//img')
    expect(page).to have_content(hiking.address)
  end

  scenario "unauthenticated user tries to join the meetup" do
    # * If I am not signed in and I click the button,
      #I should see a message which says that I must sign in.
    visit '/'
    sign_in_as user1
    hiking
    participant
    click_link "Sign Out"
    visit '/meetups'
    expect(page).to have_link('Hiking and Adventures')
    click_link('Hiking and Adventures')
    expect(page).to have_content(hiking.title)
    find_button('Join Meetup').click
    # expect(page).to have_content("The message shown by the notice")
    # expect(page).not_to have_content("The message shown by the notice", wait: 3)
    #expect(page).to have_current_path("/meetups/#{hiking.id}")
    expect(page).to have_current_path("/meetups")
    expect(page).to_not have_content(hiking.address)
  end

end
