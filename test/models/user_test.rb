# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', user_name: 'Example User',
                     password: 'foobar', password_confirmation: 'foobar')

    @user_edit = User.new(name: 'Example User', user_name: 'Example User',
                          website: 'http://example.com', profile: 'sample',
                          email: 'user@example.com', tel: '08012345678', gender: 1,
                          password: 'foobar', password_confirmation: 'foobar')
  end

  test 'user should be valid' do
    assert @user.valid?
  end
  test 'user_edit should be valid' do
    assert @user_edit.valid?
  end
  test 'name should be present' do
    @user.name = '     '
    assert_not @user.valid?
  end
  test 'user_name should be present' do
    @user.user_name = '     '
    assert_not @user.valid?
  end

  test 'website validation should reject invalid url' do
    invalid_url = %w[aaaa,bbbb.co.jp]
    invalid_url.each do |val|
      @user.website = val
      assert_not @user.valid?, "#{val.inspect} should be invalid"
    end
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |val|
      @user.email = val
      assert @user.valid?, "#{val.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |val|
      @user.email = val
      assert_not @user.valid?, "#{val.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user_edit.dup
    duplicate_user.email = @user_edit.email.upcase
    @user_edit.save
    assert_not duplicate_user.valid?
  end

  test 'tel validation should reject invalid number' do
    invalid_number = %w[08012345,080-1234-5678]
    invalid_number.each do |val|
      @user.tel = val
      assert_not @user.valid?, "#{val.inspect} should be invalid"
    end
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end
end
