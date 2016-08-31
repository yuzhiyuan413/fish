 $('#charge_monthly_code_alive_report_sp_id').select2({
  theme: "bootstrap",
  placeholder: "请选择",
  allowClear: true
 });

function getModel(){
  var model = {
      tb_id: "charge_monthly_code_alive_report_list",
      attributes: {
        scrollY: false,
        scrollX: false
      },
      params: {
        charge_monthly_code_alive_report: {
          from_date: $('#charge_monthly_code_alive_report_from_date').val(),
          end_date: $('#charge_monthly_code_alive_report_end_date').val(),
          code: $('#charge_monthly_code_alive_report_code').val(),
          dest_number: $('#charge_monthly_code_alive_report_dest_number').val(),
          sp_id: $('#charge_monthly_code_alive_report_sp_id').val()
        }
      },
      set_class: function(el, item){
        var codeName = item.attributes.code + '_' + item.attributes.dest_number;
        var codeIndex = $("#charge_monthly_code_alive_report_list th[tag='code']").index();
        $($(el).children()[codeIndex]).text(codeName);

        var id = item.attributes.id;
        var idIndex = $("#charge_monthly_code_alive_report_list th[tag='id']").index();
        var $editLink = $('<a></a>').attr('href', '/charge/monthly_code_alive_reports/' + id + '/edit').text('编辑');
        $($(el).children()[idIndex]).text('').append($editLink);

        var dateIndex = $('#charge_monthly_code_alive_report_list th[tag=report_date]').index();
        var reportDate = item.attributes.report_date;
        var matchData = reportDate.match(/^(\d{4})-(\d{2})-\d{2}$/);
        var year = matchData[1];
        var month = matchData[2];
        $($(el).children()[dateIndex]).text(year + '年' + month + '月');
      }
  }
  return model;
}

$(".ladda-button").on("click",function(){
    $("#charge_monthly_code_alive_report_list").DataTable().destroy();
    $("#charge_monthly_code_alive_report_list tbody").html('');
    new DeviceListView(getModel())
});

new DeviceListView(getModel());
