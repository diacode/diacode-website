---
title: Wizards - Painless witchcrafting Multi-Step Forms
date: 2015-11-25 09:01 UTC
author: artur
excerpt: Doing multi-page forms can be tricky, especially if we want to validate user input on each step. This solution decouples validations from models to form objects and sets you free.
tags:
  - ruby on rails
  - reform
  - wicked
  - wizards
  - form objects
---
###Multi-step forms and Rails (not a love story)
Web is huge. Data that is being collected on the web is even bigger. Often we need to gather a lot of information from the user, before we can proceed with some action. 

For the sake of this post, we will use "just a simple" registration form for a marketplace user who is a seller. Because we want our marketplace to be top-notch, or just reliable for other users, we validate all sellers that come to our platform. First step of that validation is to fill all required data, and we require a lot. So we decide to split the form into multiple parts and create a multi-step form ("wizard") to make user expierience bit easier. Unfortunetly, easier for the user doesn't mean easier implementation.

The main problem with doing wizards on Rails are partial model validations. Basically, you are using generic rails validations, you split a model into multiple-pages and while you want to save it after first step, you are still missing data so it halts you for that. There are many solutions to that problem, in this post we will see how we can use form objects to decouple validations from the models, and proceed easily with our form.

### Solution

Let's start implementing our wizard. We don't want to reinvent the wheel here, so we will use well known in Rails community gem for wizard - [wicked](https://github.com/schneems/wicked) which "hides all the really nasty stuff you shouldn't do in a controller to make this (wizards) possible". With wizard, basic sign up wizard controller would look like so:

```
class SellerSignUpController < ApplicationController
  include Wizard::Wicked
  steps :basic_info, :profile, :contact_details

  def show
  end
  
  def update
  end
end
```
And simple data model:

```
class Seller < ActiveRecord::Base
  validates :first_name, :last_name, :phone, presence: true
  has_one :profile
end

class Profile < ActiveRecord::Base
  validates :bio, presence: true
 end
```

So we can see, that if we want to split data from ```Seller``` model to different step, if we try to save the model, validations will fail.
To solve this problem, we will decouple validations from the models into form objects.
Instead of implementing form objects from scratch, we will use [reform](https://github.com/apotonick/reform), which gives us validations and nested setup of models, which helps us a lot as we don't have to implement those on our own (although it's not that hard). 

The way we are going to solve partial validations here is: we will create form object per each step of wizard like so:


```
class BasicInfoForm < Reform::Form
  property :first_name
  property :last_name
end

class ProfileForm < Reform::Form
  property :bio
end

class ContactDetailsForm
  property :phone
end
```

We will move out validations from models:

```
class Seller < ActiveRecord::Base
  has_one :profile
end

class Profile < ActiveRecord::Base
end
```

Uff, how clean! Now we just need to put validations that we need on form objects:

```
class BasicInfoForm < Reform::Form
  property :first_name
  property :last_name
  
  validates :first_name, :last_name, presence: true
end

class ProfileForm < Reform::Form
  property :bio
  
  validates :bio, presence: true
end

class ContactDetailsForm
  property :phone
  
  validates :phone, presence: true
end
```

Validations are often contextual (like in this case), so extracting them to another layer like form objects makes a lot of sense and gives your code more flexibility. It also solves problem of partial validations in wizards, so now we just need to implement a need to controller to handle that:

```
class SellerSignUpController < ApplicationController
  include Wizard::Wicked
  steps :basic_info, :profile, :contact_details

  def	show
    render_wizard
  end

  def update
    render_wizard form
  end


  def form
    @form = form_object.new(model)
  end
  
  def model
    @model = case step
      when :basic_info then current_user
      when :profile then current_user.profile
      when :contact_details then current_user
      end
  end
  
  def form_object
    case step
    when :basic_info then BasicInfoForm
    when :profile then ProfileForm
    when :contact_details then ContactDetailsForm
    end
  end
end
```

Using simple ```case``` statement we can use different models and forms for different steps, pretty neat.


###Last valid step

In our user interface we want to indicate user on what page he currently is, what steps he already finished and what is ahead. But we don't want user to go further than he filled valid data, for that we will use a before_filter, checking if the previous steps are valid and redirecting to them if not:

```
class SellerSignUpController < ApplicationController
before_filter :redirect_to_first_invalid_step

####

  private

  def redirect_to_first_invalid_step
  	# don't check previous steps on first step
    return if steps[0] == step
    steps.to(steps.index(step) - 1).each do |s|
      jump_to s unless form_object(s).new(model).validate({})
    end
  end

####
end
```

###Final word

As always, there is no one right solution, you can also go different way like in this [example](https://github.com/schneems/wicked/wiki/Building-Partial-Objects-Step-by-Step). It's worth to know all the different possiblities to choose one that will suite your application the best.
Personally, I used presented here pattern successfully more than once, and it usually paid off. 

