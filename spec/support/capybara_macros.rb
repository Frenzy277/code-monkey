def sign_in(user=nil)
  user = user || Fabricate(:user)
  visit sign_in_path

  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_on "Sign in"
end

def expect_to_be_in(url)
  expect(current_url).to eq(url)
end

def expect_url(url)
  expect(current_url).to eq(url)
end

def expect_to_see(text)
  expect(page).to have_content text
end

def expect_to_not_see(text)
  expect(page).to have_no_content text
end