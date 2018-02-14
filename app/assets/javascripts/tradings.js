function update()
  {
    $.get('/trade_list', function(data)
    {
      $('.trading-list').html(data);
    });
  }

$(document).ready(function(){
  window.setInterval('update()', 20*1000);
});
