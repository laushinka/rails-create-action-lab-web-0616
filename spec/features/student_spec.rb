require 'rails_helper'

describe 'Route to view' do
  it 'has an index page' do
    visit students_path
    expect(page.status_code).to eq(200)
  end
end

describe 'Multiple students are shown' do
  let(:index_page_student) { FactoryGirl.create(:student) }

  it 'on the index page' do
    FactoryGirl.create(:second_student)
    visit students_path
    expect(page).to have_content(/Daenerys|Lindsey/)
  end
end

describe 'form page' do
  it 'form renders with the new action' do
    visit new_student_path
    expect(page).to have_content("Student Form")
  end

  it 'new form submits content and renders form content' do
    visit new_student_path

    fill_in 'first_name', with: "Margaery"
    fill_in 'last_name', with: "Tyrell"

    click_on "Submit Student"

    expect(page).to have_content("Margaery")
  end

  it 'creates a record in the database' do
    visit new_student_path

    fill_in 'first_name', with: "Sansa"
    fill_in 'last_name', with: "Stark"

    click_on "Submit Student"

    expect(Student.last.first_name).to eq("Sansa")
  end
end

describe 'Show page' do
  let(:show_page_student) { FactoryGirl.create(:student) }

  it 'renders properly' do
    visit student_path(show_page_student)
    expect(page.status_code).to eq(200)
  end

  it 'renders the first name in a h1 tag' do
    visit student_path(show_page_student)
    expect(page).to have_css("h1", text: "Daenerys")
  end

  it 'renders the last name in a h1 tag' do
    visit student_path(show_page_student)
    expect(page).to have_css("h1", text: "Targaryen")
  end
end

describe 'linking from the index page to the show page' do
  it 'index page links to student page' do
    linked_student = FactoryGirl.create(:student)
    visit students_path
    expect(page).to have_link(linked_student.to_s, href: student_path(linked_student))
  end
end