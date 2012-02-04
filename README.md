# Rails Bootstrap Builder
Author: [The Working Group](http://www.theworkinggroup.ca)

---

## What is it?

A Rails form builder to simplify your forms and keep your views clean.
  
  
## Installation

Add gem definition to your Gemfile:
    
    gem 'rails-bootstrap-builder'
    
Then from the Rails project's root run:
    
    bundle install
    
## Usage (with haml)

    = bootstrap_form_for @session_user, :url => login_path do |f|
      = f.text_field :email, :label => 'Email address'
      = f.password_field :password
      = f.check_box :remember_me, :label => 'Remember me when I come back'
      = f.submit 'Log In', :change_to_text => 'Logging you in ...', :image => true
  
