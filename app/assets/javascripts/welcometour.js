$(document).ready(function() {
  var tour = new Tour();

  tour.addStep({
    path: "/",
    element: "a.brand",
    placement: "bottom",
    title: "Welcome Tour",
    content: "Welcome to StudyHeist!  Let me show you around."
  });
  tour.addStep({
    path: "/",
    element: "#school_name",
    placement: "bottom",
    title: "Welcome Tour",
    content: "StudyHeist is the best way to find what you need" +
    " for class.  Let's start by searching for some files..."
  });
  tour.addStep({
    path: "/",
    element: "#school_browse",
    placement: "bottom",
    title: "Welcome Tour",
    content: "I've filled in the form for you." +
    " Please click next to continue...",
    onShow: function() {
      $('#school_name').val('University of Pennsylvania');
      search = true;
    }
  });
  tour.addStep({
    path: "/search?school=University%20of%20Pennsylvania",
    element: ".table-striped",
    placement: "top",
    title: "Welcome Tour",
    content: "Great!  Here are some search results!" + 
    " All of these files were uploaded by students like you."
  });
  tour.addStep({
    path: "/search?school=University%20of%20Pennsylvania",
    element: ".table-striped",
    placement: "top",
    title: "Welcome Tour",
    content: "You can click on the blue cloud icon to download a file, " +
    "but let's finish the tour first."
  });
  tour.addStep({
    path: "/search?school=University%20of%20Pennsylvania",
    element: ".table-striped",
    placement: "top",
    title: "Welcome Tour",
    content: "You might be wondering what makes StudyHeist so special." +
    " It's the fact that you earn free downloads by sharing your files." +
    " When you give to the community, the community gives back." +
    " <br /> <a href='/signup' class='a-dot-rev end'>Click here to sign up" + 
    ", it's free!</a>",
    onShow: function() {
      over = true;
    },
    onHide: function() {
      document.location.href = "/signup";
    }
  });
  if(!tour.ended()) {
    tour.start();
  }
});