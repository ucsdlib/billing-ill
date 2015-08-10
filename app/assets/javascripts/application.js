// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require jquery.infinitescroll
//= require_tree .


$(function(){
  // JIRA issue collector
  jQuery.ajax({
            url: "https://lib-jira.ucsd.edu:8443/s/570923a7ebac454f838812ae4e331542-T/en_USfs3qxk/64016/6/1.4.25/_/download/batch/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs.js?locale=en-US&collectorId=fe10b84c",
        type: "get",
    cache: true,
    dataType: "script"
  });
  
  // homepage search form
  $('.front-search-form-recharge').hide();
  $('.front-search-form-invoice').hide();
  // $('ol.front-search-parent').children().click(function(){
    
  //   $(this).children('.front-search-form').slideToggle('slow');
  //   event.preventDefault();     
  // });
 $('li.front-search-recharge').click(function(){
        $('.front-search-form-recharge').slideToggle('slow');
 });
 $('li.front-search-invoice').click(function(){
        $('.front-search-form-invoice').slideToggle('slow');
 });
});
