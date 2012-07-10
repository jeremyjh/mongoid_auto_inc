# -*- coding: utf-8 -*-
# rspec spec/mongoid_auto_inc_spec.rb
require 'bundler/setup'
Bundler.require(:default, :development)
require 'mongoid_auto_inc'

describe MongoidAutoInc do

  before(:all) do
    Mongoid.configure do |config|
      config.sessions = { default: { hosts: [ "127.0.0.1:27017" ], database: 'mongoid_auto_inc_test'}}
      config.connect_to("mongoid_auto_inc_test")
    end
  end

  describe "auto increment" do
    before(:all) do
      class DocumentA
        include Mongoid::Document
        auto_increment :seq
      end
    end

    before(:each) do
      Mongoid.default_session["__sequences"].drop
    end

    it "should be nil" do
      DocumentA.new.seq.should be_nil
    end

    it "should be 1" do
      DocumentA.create!.seq.should == 1
    end

    it "should be 2" do
      DocumentA.create!
      DocumentA.create!.seq.should == 2
    end

    it "should not auto increment when value is provided" do
      doc = DocumentA.create!(seq: 33)
      doc.seq.should == 33
    end
  end

  describe "auto increment with :collection option" do
    before(:all) do
      class DocumentB
        include Mongoid::Document
        auto_increment :seq, :collection => 'other_sequences'
      end
    end

    before(:each) do
      Mongoid.default_session["__sequences"].drop
      Mongoid.default_session["other_sequences"].drop
    end

    it "should store sequence data to other_sequences collection" do
      DocumentB.create!.seq.should == 1
      DocumentB.create!.seq.should == 2
      Mongoid.default_session["__sequences"].drop
      DocumentB.create!.seq.should == 3
      Mongoid.default_session["other_sequences"].drop
      DocumentB.create!.seq.should == 1
    end
  end

  describe "auto increment with :seed option" do
    before(:all) do
      class DocumentC
        include Mongoid::Document
        auto_increment :seq, :seed => 10
      end
      class DocumentD
        include Mongoid::Document
        auto_increment :seq
      end
    end

    before(:each) do
      Mongoid.default_session["__sequences"].drop
    end

    it "should start with 11 (10 + 1)" do
      DocumentC.create!.seq.should == 11
      DocumentC.create!.seq.should == 12
      DocumentC.create!.seq.should == 13
      DocumentD.create!.seq.should == 1
      DocumentD.create!.seq.should == 2
    end
  end

  describe "auto increment with scope option" do
    before(:all) do
      class DocumentE
        include Mongoid::Document

        field :tenant_id
        auto_increment :seq, scope: :tenant_id
      end
    end

    before(:each) do
      Mongoid.default_session["__sequences"].drop
    end

    it "should increment scoped sequences independently" do
      e = DocumentE.create!(tenant_id: 1)
      e.seq.should == 1
      DocumentE.create!(tenant_id: 1).seq.should == 2

      DocumentE.create!(tenant_id: 2).seq.should == 1
      DocumentE.create!(tenant_id: 2).seq.should == 2

      DocumentE.create!(tenant_id: 1).seq.should == 3
    end
  end
end
