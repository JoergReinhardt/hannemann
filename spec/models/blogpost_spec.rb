# encoding: utf-8
require 'spec_helper'
 describe Blogpost do

   let(:user) { FactoryGirl.create(:user) }
   before { @blogpost = user.blogposts.build( inhalt: "Lorem Ipsum, sit amed dolor…",
                                              titel: "Titel Blog",
                                              url_slug: "blog-post",
                                            ) }

   subject { @blogpost }

   it { should respond_to(:titel) }
   it { should respond_to(:url_slug) }
   it { should respond_to(:inhalt) }
   it { should respond_to(:user_id) }
   it { should respond_to(:bild_id) }
   its(:user) { should == user }

   it { should be_valid }

   describe "Wenn user_id nicht vorhanden" do
     before { @blogpost.user_id = nil }
     it { should_not be_valid }
   end

   describe "Ohne Inhalt" do
     before { @blogpost.inhalt = " " }
   end

   describe "zugreifbare Attribute" do
     it "sollte keinen Zugriff auf user_id gewähren" do
       expect do
         Blogpost.new(user_id: user.id)
       end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
     end
   end
 end
