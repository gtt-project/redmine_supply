
function updateIssueResourceForm(){
  $('#resource_items_for_issue').html('');
  $('#resource_item_search').attr('data-value-was', '_');
  $('#resource_item_search').val('');
}

function observeResourceItemSearchfield(url) {
  $('#resource_item_search').each(function() {
    var $this = $(this);
    $this.addClass('autocomplete');
    $this.attr('data-value-was', $this.val());
    var check = function() {
      var val = $this.val();
      if ($this.attr('data-value-was') != val){
        $this.attr('data-value-was', val);
        $.ajax({
          url: url,
          type: 'get',
          data: {q: $this.val(), category_id: $('#category_id').val(), issue_id: $('#resource_item_issue_id').val()},
          success: function(data){ $('#resource_items_for_issue').html(data); },
          beforeSend: function(){ $this.addClass('ajax-loading'); },
          complete: function(){ $this.removeClass('ajax-loading'); }
        });
      }
    };
    var reset = function() {
      if (timer) {
        clearInterval(timer);
        timer = setInterval(check, 300);
      }
    };
    var timer = setInterval(check, 300);
    $this.bind('keyup click mousemove', reset);
  });
  $(document).ajaxComplete(function(){
    $('div.ui-dialog')[0].scrollIntoView()
  })
}

// issue resource item deletion
$(document).on('click', '.issue_resource_item_wrap a.icon-del', function(e){
  var wrapper = $(this).parent();
  if(wrapper.find('input[name="issue[issue_resource_items_attributes][][id]"]').val() == '') {
    wrapper.remove();
  } else {
    wrapper.find('input[name="issue[issue_resource_items_attributes][][_destroy]"]').val('1');
    wrapper.hide();
  }
  return false;
});

// issue supply item deletion
$(document).on('click', '.issue_supply_item_wrap a.icon-del', function(e){
  var wrapper = $(this).parent();
  // set quantity to zero
  wrapper.find('input[name="issue[issue_supply_items_attributes][][quantity]"]').val('0');
  // hide the whole item
  wrapper.hide();
  return false;
});


