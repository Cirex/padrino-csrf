$('form[data-remote=true]').live('submit', function(e) {
  e.preventDefault(); e.stopped = true;
  var element = $(this);
  var message = element.data('confirm');
  if (message && !confirm(message)) { return false; }
  Padrino.sendRequest(element, {
    dataType: element.data('type')   || ($.ajaxSettings && $.ajaxSettings.dataType) || 'script',
    verb:     element.data('method') || element.attr('method') || 'post',
    url:      element.attr('action'),
    params:   element.serializeArray()
  });
});

$('a[data-confirm]').live('click', function(e) {
  var message = $(this).data('confirm');
  if (!confirm(message)) { e.preventDefault(); e.stopped = true; }
});

$('a[data-remote=true]').live('click', function(e) {
  var element = $(this);
  if (e.stopped) return;
  e.preventDefault(); e.stopped = true;
  Padrino.sendRequest(element, {
    verb: element.data('method') || 'get',
    url:  element.attr('href')
  });
});

$('a[data-method]:not([data-remote])').live('click', function(e) {
  if (e.stopped) return;
  Padrino.sendMethod($(e.target));
  e.preventDefault(); e.stopped = true;
});

$.ajaxPrefilter(function(options, originalOptions, xhr){ if (!options.crossDomain) { Padrino.CSRFilter(xhr); }});

var Padrino = {
  sendRequest : function(element, options) {
    var verb = options.verb, url = options.url, params = options.params, dataType = options.dataType;
    var event = element.trigger('ajax:before');
    if (event.stopped) return false;
    $.ajax({
      url: url,
      type: verb.toUpperCase() || 'POST',
      data: params || [],
      dataType: dataType,

      beforeSend: function(request) { element.trigger('ajax:loading',  [ request ]); },
      complete:   function(request) { element.trigger('ajax:complete', [ request ]); },
      success:    function(request) { element.trigger('ajax:success',  [ request ]); },
      error:      function(request) { element.trigger('ajax:failure',  [ request ]); }
    });
    element.trigger('ajax:after');
  },

  sendMethod : function(element) {
    var verb = element.data('method');
    var url  = element.attr('href');
    var csrf_token = $('meta[name=csrf-token]').attr('content');
    var csrf_param = $('meta[name=csrf-param]').attr('content');
    
    var form = $('<form method="post" action="' + url + '"></form>');
    form.append('<input type="hidden" name="_method" value="' + verb + '">')
    if (csrf_param !== undefined && csrf_token !== undefined) {
      form.append('<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden">');
    }

    form.hide().appendTo('body');
    form.submit();
  },

  CSRFilter: function(xhr) {
    var token = $('meta[name="csrf-token"]').attr('content');
    if (token) { xhr.setRequestHeader('X-CSRF-Token', token); }
  },
};