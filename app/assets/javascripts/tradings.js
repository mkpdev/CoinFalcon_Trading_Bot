function update()
  {
    $.get('/trade_list', function(data)
    {
      $('.trading-list').html(data);
    });
  }

$(document).ready(function(){
  window.setInterval('update()', 40*1000);
});
