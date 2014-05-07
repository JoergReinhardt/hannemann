#**More at ´rubyonrails.org:´_ ** ´Overview´_ \| ´Download´_ \| ´Deploy´_ \| ´Code´_ \| ´Screencasts´_ \| ´Documentation´_ \| ´Ecosystem´_ \| ´Community´_ \| ´Blog´_

´Guides.rubyonrails.org´_
=========================

-  ´Home´_
-  ´Guides Index´_

   --------------

   Start Here
       ´Getting Started with Rails´_
   Models
       ´Rails Database Migrations´_
       ´Active Record Validations and Callbacks´_
       ´Active Record Associations´_
       ´Active Record Query Interface´_
   Views
       ´Layouts and Rendering in Rails´_
       ´Action View Form Helpers´_
   Controllers
       ´Action Controller Overview´_
       ´Rails Routing from the Outside In´_

   Digging Deeper
       ´Active Support Core Extensions´_
       ´Rails Internationalization API´_
       ´Securing Rails Applications´_
       ´Debugging Rails Applications´_
       ´Performance Testing Rails Applications´_
       ´Configuring Rails Applications´_
       ´Rails Command Line Tools and Rake Tasks´_
       ´Asset Pipeline´_
   Extending Rails
       ´Rails on Rack´_
       ´Creating and Customizing Rails Generators´_
   Contributing to Ruby on Rails
       ´Contributing to Ruby on Rails´_
       ´API Documentation Guidelines´_
       ´Ruby on Rails Guides Guidelines´_
   Release Notes
       ´Ruby on Rails 3.2 Release Notes´_
       ´Ruby on Rails 3.1 Release Notes´_
       ´Ruby on Rails 3.0 Release Notes´_
       ´Ruby on Rails 2.3 Release Notes´_
       ´Ruby on Rails 2.2 Release Notes´_

-  ´Contribute´_
-  ´Credits´_

--------------

Rails Routing from the Outside In
---------------------------------

This guide covers the user-facing features of Rails routing. By referring to this guide, you will be able to:

-  Understand the code in  routes.rb 
-  Construct your own routes, using either the preferred resourceful style or the  match  method
-  Identify what parameters to expect an action to receive
-  Automatically create paths and URLs using route helpers
-  Use advanced techniques such as constraints and Rack endpoints

#|image0|Chapters
~~~~~~~~~~~~~~~~~

#. ´The Purpose of the Rails Router´_

   -  ´Connecting URLs to Code´_
   -  ´Generating Paths and URLs from Code´_

#. ´Resource Routing: the Rails Default´_

   -  ´Resources on the Web´_
   -  ´CRUD, Verbs, and Actions´_
   -  ´Paths and URLs´_
   -  ´Defining Multiple Resources at the Same Time´_
   -  ´Singular Resources´_
   -  ´Controller Namespaces and Routing´_
   -  ´Nested Resources´_
   -  ´Creating Paths and URLs From Objects´_
   -  ´Adding More RESTful Actions´_

#. ´Non-Resourceful Routes´_

   -  ´Bound Parameters´_
   -  ´Dynamic Segments´_
   -  ´Static Segments´_
   -  ´The Query String´_
   -  ´Defining Defaults´_
   -  ´Naming Routes´_
   -  ´HTTP Verb Constraints´_
   -  ´Segment Constraints´_
   -  ´Request-Based Constraints´_
   -  ´Advanced Constraints´_
   -  ´Route Globbing´_
   -  ´Redirection´_
   -  ´Routing to Rack Applications´_
   -  ´Using  root ´_

#. ´Customizing Resourceful Routes´_

   -  ´Specifying a Controller to Use´_
   -  ´Specifying Constraints´_
   -  ´Overriding the Named Helpers´_
   -  ´Overriding the  new  and  edit  Segments´_
   -  ´Prefixing the Named Route Helpers´_
   -  ´Restricting the Routes Created´_
   -  ´Translated Paths´_
   -  ´Overriding the Singular Form´_
   -  ´Using  :as  in Nested Resources´_

#. ´Inspecting and Testing Routes´_

   -  ´Seeing Existing Routes with  rake ´_
   -  ´Testing Routes´_

1 The Purpose of the Rails Router
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Rails router recognizes URLs and dispatches them to a controller’s action. It can also generate paths and URLs, avoiding the need to hardcode strings in your views.

1.1 Connecting URLs to Code
^^^^^^^^^^^^^^^^^^^^^^^^^^^

When your Rails application receives an incoming request

 GET /patients/17 
it asks the router to match it to a controller action. If the first matching route is

 match   "/patients/:id"   =>   "patients#show" 
the request is dispatched to the  patients  controller’s  show  action with  { :id => “17” }  in  params .

1.2 Generating Paths and URLs from Code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also generate paths and URLs. If your application contains this code:

 @patient   = Patient.find(  17  ) 
 <%=   link_to   "Patient Record"  , patient_path(  @patient  )   %> 
The router will generate the path  /patients/17 . This reduces the brittleness of your view and makes your code easier to understand. Note that the id does not need to be specified in the route helper.

2 Resource Routing: the Rails Default
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Resource routing allows you to quickly declare all of the common routes for a given resourceful controller. Instead of declaring separate routes for your  index ,  show ,  new ,  edit ,  create ,  update  and  destroy  actions, a resourceful route declares them in a single line of code.

2.1 Resources on the Web
^^^^^^^^^^^^^^^^^^^^^^^^

Browsers request pages from Rails by making a request for a URL using a specific HTTP method, such as  GET ,  POST ,  PUT  and  DELETE . Each method is a request to perform an operation on the resource. A resource route maps a number of related requests to actions in a single controller.

When your Rails application receives an incoming request for

 DELETE /photos/17 
it asks the router to map it to a controller action. If the first matching route is

 resources   :photos 
Rails would dispatch that request to the  destroy  method on the  photos  controller with  { :id => “17” }  in  params .

2.2 CRUD, Verbs, and Actions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In Rails, a resourceful route provides a mapping between HTTP verbs and URLs to controller actions. By convention, each action also maps to particular CRUD operations in a database. A single entry in the routing file, such as

 resources   :photos 
creates seven different routes in your application, all mapping to the  Photos  controller:

HTTP Verb | Path             | action  | used for
GET       | /photos          | index   | display a list of all photos
GET       | /photos/new      | new     | return an HTML form for creating a new photo
POST      | /photos          | create  | create a new photo
GET       | /photos/:id      | show    | display a specific photo
GET       | /photos/:id/edit | edit    | return an HTML form for editing a photo
PUT       | /photos/:id      | update  | update a specific photo
DELETE    | /photos/:id      | destroy | delete a specific photo

Rails routes are matched in the order they are specified, so if you have a  resources :photos  above a  get 'photos/poll'  the  show  action’s route for the  resources  line will be matched before the  get  line. To fix this, move the  get  line **above** the  resources  line so that it is matched first.

2.3 Paths and URLs
^^^^^^^^^^^^^^^^^^

Creating a resourceful route will also expose a number of helpers to the controllers in your application. In the case of  resources :photos :

-   photos_path  returns  /photos 
-   new_photo_path  returns  /photos/new 
-   edit_photo_path(:id)  returns  /photos/:id/edit  (for instance,  edit_photo_path(10)  returns  /photos/10/edit )
-   photo_path(:id)  returns  /photos/:id  (for instance,  photo_path(10)  returns  /photos/10 )

Each of these helpers has a corresponding  _url  helper (such as  photos_url ) which returns the same path prefixed with the current host, port and path prefix.

Because the router uses the HTTP verb and URL to match inbound requests, four URLs map to seven different actions.

2.4 Defining Multiple Resources at the Same Time
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you need to create routes for more than one resource, you can save a bit of typing by defining them all with a single call to  resources :

 resources   :photos  ,   :books  ,   :videos 
This works exactly the same as

 resources   :photos 
 resources   :books 
 resources   :videos 
2.5 Singular Resources
^^^^^^^^^^^^^^^^^^^^^^

Sometimes, you have a resource that clients always look up without referencing an ID. For example, you would like  /profile  to always show the profile of the currently logged in user. In this case, you can use a singular resource to map  /profile  (rather than  /profile/:id ) to the  show  action.

 match   "profile"   =>   "users#show" 
This resourceful route

 resource   :geocoder 
creates six different routes in your application, all mapping to the  Geocoders  controller:

HTTP Verb | Path           | action  | used for
GET       | /geocoder/new  | new     | return an HTML form for creating the geocoder
POST      | /geocoder      | create  | create the new geocoder
GET       | /geocoder      | show    | display the one and only geocoder resource
GET       | /geocoder/edit | edit    | return an HTML form for editing the geocoder
PUT       | /geocoder      | update  | update the one and only geocoder resource
DELETE    | /geocoder      | destroy | delete the geocoder resource

Because you might want to use the same controller for a singular route ( /account ) and a plural route ( /accounts/45 ), singular resources map to plural controllers.

A singular resourceful route generates these helpers:

-   new_geocoder_path  returns  /geocoder/new 
-   edit_geocoder_path  returns  /geocoder/edit 
-   geocoder_path  returns  /geocoder 

As with plural resources, the same helpers ending in  _url  will also include the host, port and path prefix.

2.6 Controller Namespaces and Routing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may wish to organize groups of controllers under a namespace. Most commonly, you might group a number of administrative controllers under an  Admin::  namespace. You would place these controllers under the  app/controllers/admin  directory, and you can group them together in your router:

 namespace   :admin   do 
     resources   :posts  ,   :comments 
 end 

This will create a number of routes for each of the  posts  and  comments  controller. For  Admin::PostsController , Rails will create:

HTTP Verb
Path
action
named helper
GET
/admin/posts
index
admin\_posts\_path
GET
/admin/posts/new
new
new\_admin\_post\_path
POST
/admin/posts
create
admin\_posts\_path
GET
/admin/posts/:id
show
admin\_post\_path(:id)
GET
/admin/posts/:id/edit
edit
edit\_admin\_post\_path(:id)
PUT
/admin/posts/:id
update
admin\_post\_path(:id)
DELETE
/admin/posts/:id
destroy
admin\_post\_path(:id)
If you want to route  /posts  (without the prefix  /admin ) to  Admin::PostsController , you could use

 scope   :module   =>   "admin"   do 
     resources   :posts  ,   :comments 
 end 
or, for a single case

 resources   :posts  ,   :module   =>   "admin" 
If you want to route  /admin/posts  to  PostsController  (without the  Admin::  module prefix), you could use

 scope   "/admin"   do 
     resources   :posts  ,   :comments 
 end 
or, for a single case

 resources   :posts  ,   :path   =>   "/admin/posts" 
In each of these cases, the named routes remain the same as if you did not use  scope . In the last case, the following paths map to  PostsController :

HTTP Verb
Path
action
named helper
GET
/admin/posts
index
posts\_path
GET
/admin/posts/new
new
new\_post\_path
POST
/admin/posts
create
posts\_path
GET
/admin/posts/:id
show
post\_path(:id)
GET
/admin/posts/:id/edit
edit
edit\_post\_path(:id)
PUT
/admin/posts/:id
update
post\_path(:id)
DELETE
/admin/posts/:id
destroy
post\_path(:id)
2.7 Nested Resources
^^^^^^^^^^^^^^^^^^^^

It’s common to have resources that are logically children of other resources. For example, suppose your application includes these models:

 class   Magazine < ActiveRecord::Base 
     has_many   :ads 
 end 
 class   Ad < ActiveRecord::Base 
     belongs_to   :magazine 
 end 
Nested routes allow you to capture this relationship in your routing. In this case, you could include this route declaration:

 resources   :magazines   do 
     resources   :ads 
 end 
In addition to the routes for magazines, this declaration will also route ads to an  AdsController . The ad URLs require a magazine:

HTTP Verb
Path
action
used for
GET
/magazines/:magazine\_id/ads
index
display a list of all ads for a specific magazine
GET
/magazines/:magazine\_id/ads/new
new
return an HTML form for creating a new ad belonging to a specific magazine
POST
/magazines/:magazine\_id/ads
create
create a new ad belonging to a specific magazine
GET
/magazines/:magazine\_id/ads/:id
show
display a specific ad belonging to a specific magazine
GET
/magazines/:magazine\_id/ads/:id/edit
edit
return an HTML form for editing an ad belonging to a specific magazine
PUT
/magazines/:magazine\_id/ads/:id
update
update a specific ad belonging to a specific magazine
DELETE
/magazines/:magazine\_id/ads/:id
destroy
delete a specific ad belonging to a specific magazine
This will also create routing helpers such as  magazine_ads_url  and  edit_magazine_ad_path . These helpers take an instance of Magazine as the first parameter ( magazine_ads_url(@magazine) ).

2.7.1 Limits to Nesting
'''''''''''''''''''''''

You can nest resources within other nested resources if you like. For example:

 resources   :publishers   do 
     resources   :magazines   do 
       resources   :photos 
     end 
 end 
Deeply-nested resources quickly become cumbersome. In this case, for example, the application would recognize paths such as

::

    /publishers/1/magazines/2/photos/3

The corresponding route helper would be  publisher_magazine_photo_url , requiring you to specify objects at all three levels. Indeed, this situation is confusing enough that a popular ´article´_ by Jamis Buck proposes a rule of thumb for good Rails design:

*Resources should never be nested more than 1 level deep.*

2.8 Creating Paths and URLs From Objects
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In addition to using the routing helpers, Rails can also create paths and URLs from an array of parameters. For example, suppose you have this set of routes:

 resources   :magazines   do 
     resources   :ads 
 end 
When using  magazine_ad_path , you can pass in instances of  Magazine  and  Ad  instead of the numeric IDs.

 <%=   link_to   "Ad details"  , magazine_ad_path(  @magazine  ,   @ad  )   %> 
You can also use  url_for  with a set of objects, and Rails will automatically determine which route you want:

 <%=   link_to   "Ad details"  , url_for([  @magazine  ,   @ad  ])   %> 
In this case, Rails will see that  @magazine  is a  Magazine  and  @ad  is an  Ad  and will therefore use the  magazine_ad_path  helper. In helpers like  link_to , you can specify just the object in place of the full  url_for  call:

 <%=   link_to   "Ad details"  , [  @magazine  ,   @ad  ]   %> 
If you wanted to link to just a magazine, you could leave out the  Array :

 <%=   link_to   "Magazine details"  ,   @magazine   %> 
This allows you to treat instances of your models as URLs, and is a key advantage to using the resourceful style.

2.9 Adding More RESTful Actions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You are not limited to the seven routes that RESTful routing creates by default. If you like, you may add additional routes that apply to the collection or individual members of the collection.

2.9.1 Adding Member Routes
''''''''''''''''''''''''''

To add a member route, just add a  member  block into the resource block:

 resources   :photos   do 
     member   do 
       get   'preview' 
     end 
 end 
This will recognize  /photos/1/preview  with GET, and route to the  preview  action of  PhotosController . It will also create the  preview_photo_url  and  preview_photo_path  helpers.

Within the block of member routes, each route name specifies the HTTP verb that it will recognize. You can use  get ,  put ,  post , or  delete  here. If you don’t have multiple  member  routes, you can also pass  :on  to a route, eliminating the block:

 resources   :photos   do 
     get   'preview'  ,   :on   =>   :member 
 end 
2.9.2 Adding Collection Routes
''''''''''''''''''''''''''''''

To add a route to the collection:

 resources   :photos   do 
     collection   do 
       get   'search' 
     end 
 end 
This will enable Rails to recognize paths such as  /photos/search  with GET, and route to the  search  action of  PhotosController . It will also create the  search_photos_url  and  search_photos_path  route helpers.

Just as with member routes, you can pass  :on  to a route:

 resources   :photos   do 
     get   'search'  ,   :on   =>   :collection 
 end 
2.9.3 A Note of Caution
'''''''''''''''''''''''

If you find yourself adding many extra actions to a resourceful route, it’s time to stop and ask yourself whether you’re disguising the presence of another resource.

3 Non-Resourceful Routes
~~~~~~~~~~~~~~~~~~~~~~~~

In addition to resource routing, Rails has powerful support for routing arbitrary URLs to actions. Here, you don’t get groups of routes automatically generated by resourceful routing. Instead, you set up each route within your application separately.

While you should usually use resourceful routing, there are still many places where the simpler routing is more appropriate. There’s no need to try to shoehorn every last piece of your application into a resourceful framework if that’s not a good fit.

In particular, simple routing makes it very easy to map legacy URLs to new Rails actions.

3.1 Bound Parameters
^^^^^^^^^^^^^^^^^^^^

When you set up a regular route, you supply a series of symbols that Rails maps to parts of an incoming HTTP request. Two of these symbols are special:  :controller  maps to the name of a controller in your application, and  :action  maps to the name of an action within that controller. For example, consider one of the default Rails routes:

 match   ':controller(/:action(/:id))' 
If an incoming request of  /photos/show/1  is processed by this route (because it hasn’t matched any previous route in the file), then the result will be to invoke the  show  action of the  PhotosController , and to make the final parameter  "1"  available as  params[:id] . This route will also route the incoming request of  /photos  to  PhotosController#index , since  :action  and  :id  are optional parameters, denoted by parentheses.

3.2 Dynamic Segments
^^^^^^^^^^^^^^^^^^^^

You can set up as many dynamic segments within a regular route as you like. Anything other than  :controller  or  :action  will be available to the action as part of  params . If you set up this route:

 match   ':controller/:action/:id/:user_id' 
An incoming path of  /photos/show/1/2  will be dispatched to the  show  action of the  PhotosController .  params[:id]  will be  "1" , and  params[:user_id]  will be  "2" .

You can’t use  :namespace  or  :module  with a  :controller  path segment. If you need to do this then use a constraint on :controller that matches the namespace you require. e.g:

 match   ':controller(/:action(/:id))'  ,   :controller   => /admin\/[^\/]+/ 
By default dynamic segments don’t accept dots – this is because the dot is used as a separator for formatted routes. If you need to use a dot within a dynamic segment add a constraint which overrides this – for example  :id  => /[^\\/]+/ allows anything except a slash.

3.3 Static Segments
^^^^^^^^^^^^^^^^^^^

You can specify static segments when creating a route:

 match   ':controller/:action/:id/with_user/:user_id' 
This route would respond to paths such as  /photos/show/1/with_user/2 . In this case,  params  would be  { :controller => “photos”, :action => “show”, :id => “1”, :user_id => “2” } .

3.4 The Query String
^^^^^^^^^^^^^^^^^^^^

The  params  will also include any parameters from the query string. For example, with this route:

 match   ':controller/:action/:id' 
An incoming path of  /photos/show/1?user_id=2  will be dispatched to the  show  action of the  Photos  controller.  params  will be  { :controller => “photos”, :action => “show”, :id => “1”, :user_id => “2” } .

3.5 Defining Defaults
^^^^^^^^^^^^^^^^^^^^^

You do not need to explicitly use the  :controller  and  :action  symbols within a route. You can supply them as defaults:

 match   'photos/:id'   =>   'photos#show' 
With this route, Rails will match an incoming path of  /photos/12  to the  show  action of  PhotosController .

You can also define other defaults in a route by supplying a hash for the  :defaults  option. This even applies to parameters that you do not specify as dynamic segments. For example:

 match   'photos/:id'   =>   'photos#show'  ,   :defaults   => {   :format   =>   'jpg'   } 
Rails would match  photos/12  to the  show  action of  PhotosController , and set  params[:format]  to  "jpg" .

3.6 Naming Routes
^^^^^^^^^^^^^^^^^

You can specify a name for any route using the  :as  option.

 match   'exit'   =>   'sessions#destroy'  ,   :as   =>   :logout 
This will create  logout_path  and  logout_url  as named helpers in your application. Calling  logout_path  will return  /exit 

3.7 HTTP Verb Constraints
^^^^^^^^^^^^^^^^^^^^^^^^^

You can use the  :via  option to constrain the request to one or more HTTP methods:

 match   'photos/show'   =>   'photos#show'  ,   :via   =>   :get 
There is a shorthand version of this as well:

 get   'photos/show' 
You can also permit more than one verb to a single route:

 match   'photos/show'   =>   'photos#show'  ,   :via   => [  :get  ,   :post  ] 
3.8 Segment Constraints
^^^^^^^^^^^^^^^^^^^^^^^

You can use the  :constraints  option to enforce a format for a dynamic segment:

 match   'photos/:id'   =>   'photos#show'  ,   :constraints   => {   :id   => /[  A  -  Z  ]\d{  5  }/ } 
This route would match paths such as  /photos/A12345 . You can more succinctly express the same route this way:

 match   'photos/:id'   =>   'photos#show'  ,   :id   => /[  A  -  Z  ]\d{  5  }/ 
 :constraints  takes regular expressions with the restriction that regexp anchors can’t be used. For example, the following route will not work:

 match   '/:id'   =>   'posts#show'  ,   :constraints   => {  :id   => /^\d/} 
However, note that you don’t need to use anchors because all routes are anchored at the start.

For example, the following routes would allow for  posts  with  to_param  values like  1-hello-world  that always begin with a number and  users  with  to_param  values like  david  that never begin with a number to share the root namespace:

 match   '/:id'   =>   'posts#show'  ,   :constraints   => {   :id   => /\d.+/ } 
 match   '/:username'   =>   'users#show' 
3.9 Request-Based Constraints
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also constrain a route based on any method on the ´Request´_ object that returns a  String .

You specify a request-based constraint the same way that you specify a segment constraint:

 match   "photos"  ,   :constraints   => {  :subdomain   =>   "admin"  } 
You can also specify constraints in a block form:

 namespace   :admin   do 
     constraints   :subdomain   =>   "admin"   do 
       resources   :photos 
     end 
 end 
3.10 Advanced Constraints
^^^^^^^^^^^^^^^^^^^^^^^^^

If you have a more advanced constraint, you can provide an object that responds to  matches?  that Rails should use. Let’s say you wanted to route all users on a blacklist to the  BlacklistController . You could do:

 class   BlacklistConstraint 
     def   initialize 
       @ips   = Blacklist.retrieve_ips 
     end 
     def   matches?(request) 
       @ips  .include?(request.remote_ip) 
     end 
 end 
 TwitterClone::Application.routes.draw   do 
     match   "*path"   =>   "blacklist#index"  , 
       :constraints   => BlacklistConstraint.  new 
 end 
3.11 Route Globbing
^^^^^^^^^^^^^^^^^^^

Route globbing is a way to specify that a particular parameter should be matched to all the remaining parts of a route. For example

 match   'photos/*other'   =>   'photos#unknown' 
This route would match  photos/12  or  /photos/long/path/to/12 , setting  params[:other]  to  "12"  or  "long/path/to/12" .

Wildcard segments can occur anywhere in a route. For example,

 match   'books/*section/:title'   =>   'books#show' 
would match  books/some/section/last-words-a-memoir  with  params[:section]  equals  "some/section" , and  params[:title]  equals  "last-words-a-memoir" .

Technically a route can have even more than one wildcard segment. The matcher assigns segments to parameters in an intuitive way. For example,

 match   '*a/foo/*b'   =>   'test#index' 
would match  zoo/woo/foo/bar/baz  with  params[:a]  equals  "zoo/woo" , and  params[:b]  equals  "bar/baz" .

Starting from Rails 3.1, wildcard routes will always match the optional format segment by default. For example if you have this route:

 match   '*pages'   =>   'pages#show' 
By requesting  "/foo/bar.json" , your  params[:pages]  will be equals to  "foo/bar"  with the request format of JSON. If you want the old 3.0.x behavior back, you could supply  :format => false  like this:

 match   '*pages'   =>   'pages#show'  ,   :format   =>   false 
If you want to make the format segment mandatory, so it cannot be omitted, you can supply  :format => true  like this:

 match   '*pages'   =>   'pages#show'  ,   :format   =>   true 
3.12 Redirection
^^^^^^^^^^^^^^^^

You can redirect any path to another path using the  redirect  helper in your router:

 match   "/stories"   => redirect(  "/posts"  ) 
You can also reuse dynamic segments from the match in the path to redirect to:

 match   "/stories/:name"   => redirect(  "/posts/%{name}"  ) 
You can also provide a block to redirect, which receives the params and (optionally) the request object:

 match   "/stories/:name"   => redirect {|params|   "/posts/#{params[:name].pluralize}"   } 
 match   "/stories"   => redirect {|p, req|   "/posts/#{req.subdomain}"   } 
Please note that this redirection is a 301 “Moved Permanently” redirect. Keep in mind that some web browsers or proxy servers will cache this type of redirect, making the old page inaccessible.

In all of these cases, if you don’t provide the leading host ( http://www.example.com ), Rails will take those details from the current request.

3.13 Routing to Rack Applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Instead of a String, like  "posts#index" , which corresponds to the  index  action in the  PostsController , you can specify any ´Rack application´_ as the endpoint for a matcher.

 match   "/application.js"   => Sprockets 
As long as  Sprockets  responds to  call  and returns a  [status, headers, body] , the router won’t know the difference between the Rack application and an action.

For the curious,  "posts#index"  actually expands out to  PostsController.action(:index) , which returns a valid Rack application.

3.14 Using  root 
^^^^^^^^^^^^^^^^^^^

You can specify what Rails should route  "/"  to with the  root  method:

 root   :to   =>   'pages#main' 
You should put the  root  route at the top of the file, because it is the most popular route and should be matched first. You also need to delete the  public/index.html  file for the root route to take effect.

4 Customizing Resourceful Routes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While the default routes and helpers generated by  resources :posts  will usually serve you well, you may want to customize them in some way. Rails allows you to customize virtually any generic part of the resourceful helpers.

4.1 Specifying a Controller to Use
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The  :controller  option lets you explicitly specify a controller to use for the resource. For example:

 resources   :photos  ,   :controller   =>   "images" 
will recognize incoming paths beginning with  /photos  but route to the  Images  controller:

HTTP Verb
Path
action
named helper
GET
/photos
index
photos\_path
GET
/photos/new
new
new\_photo\_path
POST
/photos
create
photos\_path
GET
/photos/:id
show
photo\_path(:id)
GET
/photos/:id/edit
edit
edit\_photo\_path(:id)
PUT
/photos/:id
update
photo\_path(:id)
DELETE
/photos/:id
destroy
photo\_path(:id)
Use  photos_path ,  new_photo_path , etc. to generate paths for this resource.

4.2 Specifying Constraints
^^^^^^^^^^^^^^^^^^^^^^^^^^

You can use the  :constraints  option to specify a required format on the implicit  id . For example:

 resources   :photos  ,   :constraints   => {  :id   => /[  A  -  Z  ][  A  -  Z  ][  0  -  9  ]+/} 
This declaration constrains the  :id  parameter to match the supplied regular expression. So, in this case, the router would no longer match  /photos/1  to this route. Instead,  /photos/RR27  would match.

You can specify a single constraint to apply to a number of routes by using the block form:

 constraints(  :id   => /[  A  -  Z  ][  A  -  Z  ][  0  -  9  ]+/)   do 
     resources   :photos 
     resources   :accounts 
 end 
Of course, you can use the more advanced constraints available in non-resourceful routes in this context.

By default the  :id  parameter doesn’t accept dots – this is because the dot is used as a separator for formatted routes. If you need to use a dot within an  :id  add a constraint which overrides this – for example  :id  => /[^\\/]+/ allows anything except a slash.

4.3 Overriding the Named Helpers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The  :as  option lets you override the normal naming for the named route helpers. For example:

 resources   :photos  ,   :as   =>   "images" 
will recognize incoming paths beginning with  /photos  and route the requests to  PhotosController , but use the value of the :as option to name the helpers.

HTTP verb
Path
action
named helper
GET
/photos
index
images\_path
GET
/photos/new
new
new\_image\_path
POST
/photos
create
images\_path
GET
/photos/:id
show
image\_path(:id)
GET
/photos/:id/edit
edit
edit\_image\_path(:id)
PUT
/photos/:id
update
image\_path(:id)
DELETE
/photos/:id
destroy
image\_path(:id)
4.4 Overriding the  new  and  edit  Segments
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The  :path_names  option lets you override the automatically-generated “new” and “edit” segments in paths:

 resources   :photos  ,   :path_names   => {   :new   =>   'make'  ,   :edit   =>   'change'   } 
This would cause the routing to recognize paths such as

 /photos/make 
 /photos/1/change 
The actual action names aren’t changed by this option. The two paths shown would still route to the  new  and  edit  actions.

If you find yourself wanting to change this option uniformly for all of your routes, you can use a scope.

 scope   :path_names   => {   :new   =>   "make"   }   do 
     # rest of your routes 
 end 
4.5 Prefixing the Named Route Helpers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can use the  :as  option to prefix the named route helpers that Rails generates for a route. Use this option to prevent name collisions between routes using a path scope.

 scope   "admin"   do 
     resources   :photos  ,   :as   =>   "admin_photos" 
 end 
 resources   :photos 
This will provide route helpers such as  admin_photos_path ,  new_admin_photo_path  etc.

To prefix a group of route helpers, use  :as  with  scope :

 scope   "admin"  ,   :as   =>   "admin"   do 
     resources   :photos  ,   :accounts 
 end 
 resources   :photos  ,   :accounts 
This will generate routes such as  admin_photos_path  and  admin_accounts_path  which map to  /admin/photos  and  /admin/accounts  respectively.

The  namespace  scope will automatically add  :as  as well as  :module  and  :path  prefixes.

You can prefix routes with a named parameter also:

 scope   ":username"   do 
     resources   :posts 
 end 
This will provide you with URLs such as  /bob/posts/1  and will allow you to reference the  username  part of the path as  params[:username]  in controllers, helpers and views.

4.6 Restricting the Routes Created
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, Rails creates routes for the seven default actions (index, show, new, create, edit, update, and destroy) for every RESTful route in your application. You can use the  :only  and  :except  options to fine-tune this behavior. The  :only  option tells Rails to create only the specified routes:

 resources   :photos  ,   :only   => [  :index  ,   :show  ] 
Now, a  GET  request to  /photos  would succeed, but a  POST  request to  /photos  (which would ordinarily be routed to the  create  action) will fail.

The  :except  option specifies a route or list of routes that Rails should *not* create:

 resources   :photos  ,   :except   =>   :destroy 
In this case, Rails will create all of the normal routes except the route for  destroy  (a  DELETE  request to  /photos/:id ).

If your application has many RESTful routes, using  :only  and  :except  to generate only the routes that you actually need can cut down on memory use and speed up the routing process.

4.7 Translated Paths
^^^^^^^^^^^^^^^^^^^^

Using  scope , we can alter path names generated by resources:

 scope(  :path_names   => {   :new   =>   "neu"  ,   :edit   =>   "bearbeiten"   })   do 
     resources   :categories  ,   :path   =>   "kategorien" 
 end 
Rails now creates routes to the  CategoriesController .

HTTP verb
Path
action
named helper
GET
/kategorien
index
categories\_path
GET
/kategorien/neu
new
new\_category\_path
POST
/kategorien
create
categories\_path
GET
/kategorien/:id
show
category\_path(:id)
GET
/kategorien/:id/bearbeiten
edit
edit\_category\_path(:id)
PUT
/kategorien/:id
update
category\_path(:id)
DELETE
/kategorien/:id
destroy
category\_path(:id)
4.8 Overriding the Singular Form
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you want to define the singular form of a resource, you should add additional rules to the  Inflector .

 ActiveSupport::Inflector.inflections   do   |inflect| 
     inflect.irregular   'tooth'  ,   'teeth' 
 end 
4.9 Using  :as  in Nested Resources
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The  :as  option overrides the automatically-generated name for the resource in nested route helpers. For example,

 resources   :magazines   do 
     resources   :ads  ,   :as   =>   'periodical_ads' 
 end 
This will create routing helpers such as  magazine_periodical_ads_url  and  edit_magazine_periodical_ad_path .

5 Inspecting and Testing Routes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rails offers facilities for inspecting and testing your routes.

5.1 Seeing Existing Routes with  rake 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you want a complete list of all of the available routes in your application, run  rake routes  command. This will print all of your routes, in the same order that they appear in  routes.rb . For each route, you’ll see:

-  The route name (if any)
-  The HTTP verb used (if the route doesn’t respond to all verbs)
-  The URL pattern to match
-  The routing parameters for the route

For example, here’s a small section of the  rake routes  output for a RESTful route:

::

        users GET    /users(.:format)          users#index
              POST   /users(.:format)          users#create
     new_user GET    /users/new(.:format)      users#new
    edit_user GET    /users/:id/edit(.:format) users#edit

You may restrict the listing to the routes that map to a particular controller setting the  CONTROLLER  environment variable:

 $ CONTROLLER=users rake routes 
You’ll find that the output from  rake routes  is much more readable if you widen your terminal window until the output lines don’t wrap.

5.2 Testing Routes
^^^^^^^^^^^^^^^^^^

Routes should be included in your testing strategy (just like the rest of your application). Rails offers three ´built-in assertions´_ designed to make testing routes simpler:

-   assert_generates 
-   assert_recognizes 
-   assert_routing 

5.2.1 The  assert_generates  Assertion
''''''''''''''''''''''''''''''''''''''''

 assert_generates  asserts that a particular set of options generate a particular path and can be used with default routes or custom routes.

 assert_generates   "/photos/1"  , {   :controller   =>   "photos"  ,   :action   =>   "show"  ,   :id   =>   "1"   } 
 assert_generates   "/about"  ,   :controller   =>   "pages"  ,   :action   =>   "about" 
5.2.2 The  assert_recognizes  Assertion
'''''''''''''''''''''''''''''''''''''''''

 assert_recognizes  is the inverse of  assert_generates . It asserts that a given path is recognized and routes it to a particular spot in your application.

 assert_recognizes({   :controller   =>   "photos"  ,   :action   =>   "show"  ,   :id   =>   "1"   },   "/photos/1"  ) 
You can supply a  :method  argument to specify the HTTP verb:

 assert_recognizes({   :controller   =>   "photos"  ,   :action   =>   "create"   }, {   :path   =>   "photos"  ,   :method   =>   :post   }) 
5.2.3 The  assert_routing  Assertion
''''''''''''''''''''''''''''''''''''''

The  assert_routing  assertion checks the route both ways: it tests that the path generates the options, and that the options generate the path. Thus, it combines the functions of  assert_generates  and  assert_recognizes .

 assert_routing({   :path   =>   "photos"  ,   :method   =>   :post   }, {   :controller   =>   "photos"  ,   :action   =>   "create"   }) 
Feedback
~~~~~~~~

You’re encouraged to help improve the quality of this guide.

If you see any typos or factual errors you are confident to patch, please clone ´docrails´_ and push the change yourself. That branch of Rails has public write access. Commits are still reviewed, but that happens after you’ve submitted your contribution. ´docrails´_ is cross-merged with master periodically.

You may also find incomplete content, or stuff that is not up to date. Please do add any missing documentation for master. Check the ´Ruby on Rails Guides Guidelines´_ for style and conventions.

If for whatever reason you spot something to fix but cannot patch it yourself, please ´open an issue´_.

And last but not least, any kind of discussion regarding Ruby on Rails documentation is very welcome in the ´rubyonrails-docs mailing list´_.

--------------

This work is licensed under a ´Creative Commons Attribution-Share Alike 3.0´_ License

“Rails”, “Ruby on Rails”, and the Rails logo are trademarks of David Heinemeier Hansson. All rights reserved.

.. _´rubyonrails.org:´: http://rubyonrails.org/
.. _Overview: http://rubyonrails.org/
.. _Download: http://rubyonrails.org/download
.. _Deploy: http://rubyonrails.org/deploy
.. _Code: https://github.com/rails/rails
.. _Screencasts: http://rubyonrails.org/screencasts
.. _Documentation: http://rubyonrails.org/documentation
.. _Ecosystem: http://rubyonrails.org/ecosystem
.. _Community: http://rubyonrails.org/community
.. _Blog: http://weblog.rubyonrails.org/
.. _Guides.rubyonrails.org: http://guides.rubyonrails.org/index.html
.. _Home: http://guides.rubyonrails.org/index.html
.. _Guides Index: http://guides.rubyonrails.org/index.html
.. _Getting Started with Rails: http://guides.rubyonrails.org/getting_started.html
.. _Rails Database Migrations: http://guides.rubyonrails.org/migrations.html
.. _Active Record Validations and Callbacks: http://guides.rubyonrails.org/active_record_validations_callbacks.html
.. _Active Record Associations: http://guides.rubyonrails.org/association_basics.html
.. _Active Record Query Interface: http://guides.rubyonrails.org/active_record_querying.html
.. _Layouts and Rendering in Rails: http://guides.rubyonrails.org/layouts_and_rendering.html
.. _Action View Form Helpers: http://guides.rubyonrails.org/form_helpers.html
.. _Action Controller Overview: http://guides.rubyonrails.org/action_controller_overview.html
.. _Rails Routing from the Outside In: ./Ruby%20on%20Rails%20Guides%20%20Rails%20Routing%20from%20the%20Outside%20In_files/Ruby%20on%20Rails%20Guides%20%20Rails%20Routing%20from%20the%20Outside%20In.html
.. _Active Support Core Extensions: http://guides.rubyonrails.org/active_support_core_extensions.html
.. _Rails Internationalization API: http://guides.rubyonrails.org/i18n.html
.. _Securing Rails Applications: http://guides.rubyonrails.org/security.html
.. _Debugging Rails Applications: http://guides.rubyonrails.org/debugging_rails_applications.html
.. _Performance Testing Rails Applications: http://guides.rubyonrails.org/performance_testing.html
.. _Configuring Rails Applications: http://guides.rubyonrails.org/configuring.html
.. _Rails Command Line Tools and Rake Tasks: http://guides.rubyonrails.org/command_line.html
.. _Asset Pipeline: http://guides.rubyonrails.org/asset_pipeline.html
.. _Rails on Rack: http://guides.rubyonrails.org/rails_on_rack.html
.. _Creating and Customizing Rails Generators: http://guides.rubyonrails.org/generators.html
.. _Contributing to Ruby on Rails: http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html
.. _API Documentation Guidelines: http://guides.rubyonrails.org/api_documentation_guidelines.html
.. _Ruby on Rails Guides Guidelines: http://guides.rubyonrails.org/ruby_on_rails_guides_guidelines.html
.. _Ruby on Rails 3.2 Release Notes: http://guides.rubyonrails.org/3_2_release_notes.html
.. _Ruby on Rails 3.1 Release Notes: http://guides.rubyonrails.org/3_1_release_notes.html
.. _Ruby on Rails 3.0 Release Notes: http://guides.rubyonrails.org/3_0_release_notes.html
.. _Ruby on Rails 2.3 Release Notes: http://guides.rubyonrails.org/2_3_release_notes.html
.. _Ruby on Rails 2.2 Release Notes: http://guides.rubyonrails.org/2_2_release_notes.html
.. _Contribute: http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html
.. _Credits: http://guides.rubyonrails.org/credits.html
.. _The Purpose of the Rails Router: http://guides.rubyonrails.org/routing.html#the-purpose-of-the-rails-router
.. _Connecting URLs to Code: http://guides.rubyonrails.org/routing.html#connecting-urls-to-code
.. _Generating Paths and URLs from Code: http://guides.rubyonrails.org/routing.html#generating-paths-and-urls-from-code
.. _´Resource Routing: the Rails Default´: http://guides.rubyonrails.org/routing.html#resource-routing-the-rails-default
.. _Resources on the Web: http://guides.rubyonrails.org/routing.html#resources-on-the-web
.. _CRUD, Verbs, and Actions: http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions
.. _Paths and URLs: http://guides.rubyonrails.org/routing.html#paths-and-urls
.. _Defining Multiple Resources at the Same Time: http://guides.rubyonrails.org/routing.html#defining-multiple-resources-at-the-same-time
.. _Singular Resources: http://guides.rubyonrails.org/routing.html#singular-resources
.. _Controller Namespaces and Routing: http://guides.rubyonrails.org/routing.html#controller-namespaces-and-routing
.. _Nested Resources: http://guides.rubyonrails.org/routing.html#nested-resources
.. _Creating Paths and URLs From Objects: http://guides.rubyonrails.org/routing.html#creating-paths-and-urls-from-objects
.. _Adding More RESTful Actions: http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
.. _Non-Resourceful Routes: http://guides.rubyonrails.org/routing.html#non-resourceful-routes
.. _Bound Parameters: http://guides.rubyonrails.org/routing.html#bound-parameters
.. _Dynamic Segments: http://guides.rubyonrails.org/routing.html#dynamic-segments
.. _Static Segments: http://guides.rubyonrails.org/routing.html#static-segments
.. _The Query String: http://guides.rubyonrails.org/routing.html#the-query-string
.. _Defining Defaults: http://guides.rubyonrails.org/routing.html#defining-defaults
.. _Naming Routes: http://guides.rubyonrails.org/routing.html#naming-routes
.. _HTTP Verb Constraints: http://guides.rubyonrails.org/routing.html#http-verb-constraints
.. _Segment Constraints: http://guides.rubyonrails.org/routing.html#segment-constraints
.. _Request-Based Constraints: http://guides.rubyonrails.org/routing.html#request-based-constraints
.. _Advanced Constraints: http://guides.rubyonrails.org/routing.html#advanced-constraints
.. _Route Globbing: http://guides.rubyonrails.org/routing.html#route-globbing
.. _Redirection: http://guides.rubyonrails.org/routing.html#redirection
.. _Routing to Rack Applications: http://guides.rubyonrails.org/routing.html#routing-to-rack-applications
.. _Using  root : http://guides.rubyonrails.org/routing.html#using-root
.. _Customizing Resourceful Routes: http://guides.rubyonrails.org/routing.html#customizing-resourceful-routes
.. _Specifying a Controller to Use: http://guides.rubyonrails.org/routing.html#specifying-a-controller-to-use
.. _Specifying Constraints: http://guides.rubyonrails.org/routing.html#specifying-constraints
.. _Overriding the Named Helpers: http://guides.rubyonrails.org/routing.html#overriding-the-named-helpers
.. _Overriding the  new  and  edit  Segments: http://guides.rubyonrails.org/routing.html#overriding-the-new-and-edit-segments
.. _Prefixing the Named Route Helpers: http://guides.rubyonrails.org/routing.html#prefixing-the-named-route-helpers
.. _Restricting the Routes Created: http://guides.rubyonrails.org/routing.html#restricting-the-routes-created
.. _Translated Paths: http://guides.rubyonrails.org/routing.html#translated-paths
.. _Overriding the Singular Form: http://guides.rubyonrails.org/routing.html#overriding-the-singular-form
.. _´Using  :as  in Nested Resources´: http://guides.rubyonrails.org/routing.html#nested-names
.. _Inspecting and Testing Routes: http://guides.rubyonrails.org/routing.html#inspecting-and-testing-routes
.. _Seeing Existing Routes with  rake : http://guides.rubyonrails.org/routing.html#seeing-existing-routes-with-rake
.. _Testing Routes: http://guides.rubyonrails.org/routing.html#testing-routes
.. _article: http://weblog.jamisbuck.org/2007/2/5/nesting-resources
.. _Request: http://guides.rubyonrails.org/action_controller_overview.html#the-request-object
.. _Rack application: http://guides.rubyonrails.org/rails_on_rack.html
.. _built-in assertions: http://api.rubyonrails.org/classes/ActionDispatch/Assertions/RoutingAssertions.html
.. _docrails: https://github.com/lifo/docrails
.. _open an issue: https://github.com/rails/rails/issues
.. _rubyonrails-docs mailing list: http://groups.google.com/group/rubyonrails-docs
.. _Creative Commons Attribution-Share Alike 3.0: http://creativecommons.org/licenses/by-sa/3.0/

.. |image0| image:: ./Ruby%20on%20Rails%20Guides%20%20Rails%20Routing%20from%20the%20Outside%20In_files/chapters_icon.gif
