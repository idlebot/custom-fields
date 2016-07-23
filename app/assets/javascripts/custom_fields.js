$(document).on('turbolinks:load', function() {
  // set up UJS only for views based on the CustomFieldsController
  if ($('body[data-controller="custom_fields"]').length === 0) {
    return;
  }

  if ($('body[data-action="new"]').length === 1) {
    newActionUJSSetup();
  }
});

function newActionUJSSetup() {

  function showDropDownValueEditor() {
    $('.drop-down-values-editor').show();
  }

  function hideDropDownValueEditor() {
    $('.drop-down-values-editor').hide();
  }

  $(document).on('click', '#TextCustomField_option', function(event) {
    $('#custom_field_type').val('TextCustomField');
    hideDropDownValueEditor();
  });

  $(document).on('click', '#TextAreaCustomField_option', function(event) {
    $('#custom_field_type').val('TextAreaCustomField');
    hideDropDownValueEditor();
  });

  $(document).on('click', '#DropDownCustomField_option', function(event) {
    $('#custom_field_type').val('DropDownCustomField');
    showDropDownValueEditor();
  });
}
