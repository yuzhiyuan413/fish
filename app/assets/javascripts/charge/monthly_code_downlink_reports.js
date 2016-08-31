$('#charge_monthly_code_downlink_report_code_name').select2({
 theme: "bootstrap",
 placeholder: "请选择",
 allowClear: true
});

$('.expandable-arrow').click(function(){
  var $this = $(this);
  var rowLinkId = $this.parents('tr').attr('data-row-id');
  var $dailyRows = $('.row-daily[data-row-id=' + rowLinkId + ']');
  var visible = $dailyRows.is(':visible');
  if (visible){
    $dailyRows.hide();
    $(this).find('span').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-right');
  } else {
    $dailyRows.show();
    $(this).find('span').removeClass('glyphicon-triangle-right').addClass('glyphicon-triangle-bottom');
  }
});