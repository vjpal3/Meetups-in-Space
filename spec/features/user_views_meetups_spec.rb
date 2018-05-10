require 'spec_helper'

feature 'user views available meetups' do
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

  let(:fitness) do
    Meetup.create(
      title: 'Fitness Together', creator_id: "#{user1.id}",
      description: 'From easy exercises to challenging workouts, heres how to get in the best shape of your life.',
      address: '123 Pear St.', city: 'Boston',
      state: 'MA', zip: '23456'
    )
  end

  scenario 'view list of all meetups in alphabetical order' do
    # As a user
    # I want to view a list of all available meetups
    # So that I can get together with people with similar interests

    # Acceptance Criteria:
    #
    # * On the meetups index page, I should see the name of each meetup.
    # * Meetups should be listed alphabetically.

    # First create some sample meetups
    hiking
    fitness

    visit '/meetups'
    expect(page).to have_content(hiking.title)
    expect(page).to have_content "#{fitness.title}"
    # expect(page.body.index('Fitness Together') < page.body.index('Hiking and Adventures')).to eq true
    expect(page.body.index("#{fitness.title}") < page.body.index("#{hiking.title}")).to eq true
  end

  scenario "view details for a meetup" do
    # As a user
    # I want to view the details of a meetup
    # So that I can learn more about its purpose
    #
    # Acceptance Criteria:
    # * On the index page, the name of each meetup should be a link to the meetup's show page.
    # * On the show page, I should see the name, description, location, and the creator of the meetup.
    # user = User.create
    # hiking = Meetup.create!({
    #     title: 'Hiking and Adventures', creator_id: 1,
    #     address: '123 Apple St.', city: 'Providence',
    #     state: 'RI', zip: '02906'
    # })
    visit '/'
    sign_in_as user1
    hiking
    click_link "Sign Out"

    visit '/meetups'
    expect(page).to have_link('Hiking and Adventures')
    click_link('Hiking and Adventures')
    expect(page).to have_content(hiking.title)
    expect(page).to have_content(user1.username)
    expect(page).to have_content(hiking.description)
    expect(page).to have_content(hiking.category)
    expect(page).to have_content(hiking.location)
    expect(page).to have_content(hiking.city)
    expect(page).to have_content(hiking.state)
    expect(page).to have_content(hiking.zip)
  end
end
