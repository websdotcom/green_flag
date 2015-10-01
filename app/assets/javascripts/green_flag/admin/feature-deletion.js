$('#delete-flag-button').click(function(event) {
  event.preventDefault();

  var response = prompt("The feature and all associated rules and decisions will " + 
    "be permanently deleted. If you are sure you understand the consequences, type " +
    "\"DESTROY\" below.");

  switch(response) {
    case "DESTROY":
      $.ajax({
        url: event.currentTarget.baseURI,
        type: "DELETE"
      }).done(function() {
        window.location.href = event.currentTarget.baseURI;
      });

      break;
    default:
      break;
  }
});
