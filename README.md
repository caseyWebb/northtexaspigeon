# NorthTexasPigeon.com

The North Texas Pigeon is written using SailsJS and
uses AngularJS on the admin CMS.

This is the second iteration of the NTP, and when rewriting
it I had two major goals in mind:
  - make it faster (we found nearly 90% of our traffic is mobile, and the UX on mobile was less than spectacular)
  - make it easier for the writers (no one knows markdown except for programmers, apparently)

So, before you dive in, I'll give you a quick tour of how I accomplished
those two goals...


### Making it faster

While the Pigeon was never particulary slow on desktop, on phones
pages were taking up to 30 seconds to load fully sometimes. Not to
mention for every page a user visited, the browser was performing a
full page reload. Neither of these were acceptable; the site needed
to be nimble enough to read through a couple articles between the main
campus and Discovery Park.

What I needed was a way to do partial page loads with minimal JS, and
retain search engine crawlability (this is important for the public
facing portion of the site, not so much for the admin).

__The solution:__

Deliever the landing page as usual -- fully rendered from the server, and
fully crawlable (with FB OG Meta tags and all) -- and request new pages
via AJAX. If you take a look at the DOM, you'll notice a #Stage element;
this guy is important. What happens is, when you click a link (well, actually
when you hover it... more on that later...), and AJAX call is sent to the
server and it passes two params: noLayout=true and forceHTML=true.

The first is picked up in Jade view, and excludes the header and footer, sending
back only the #Stage element I mentioned above. The second tells Sails to send
rendered HTML instead of JSON. That rendered HTML partial is then swapped in using
simple jQuery, and the URL and page title are updated with HTML5 PushState.

_But what about that hover thing???_
Ahh yes, preloading. Rather than doing all of that work on click, when a user
hovers over a link for more than 400ms, the AJAX call is sent to retrieve the HTML
partial and stored in a cache, ready to be swapped in on click. This cache sticks
around until the page is reloaded or the user navigates away, so flipping back and
forth between pages is near instant.

__One more thing!__ 
Previously, writers would upload any images to TinyPic, and then sub in the link.
This was necessary because we didn't have enough bandwidth to serve our own images.
Now we're on DigitalOcean, though, and we have plenty, which means pre-processing
is now possible, and it's exactly what we do. Every image uploaded is processed
using GraphicsMagick on the server into three sizes and compressed. This prevents
huge images from being loaded into thumbnails. No more waste.


### Making it easier

When the Pigeon was first written, I decided to use Markdown as the authoring format.
I despise WYSIWYG editors, and I honestly think Markdown is simply better when
the target format is HTML. Buuut, most non-nerds don't know Markdown. So, the solution
was obvious, an article preview. Alongside the textbox, there is a fully formatted
preview using an Angular filter. This filter also inlines hashtags, and previews images.
Speaking of images, those are drag and drop now, or right click to enter. No more
back and forth between TinyPic and the Pigeon uploading images and copying links. Just
drag it into the article where you want it.

Email and writer management were also cumbersome and needed to be addressed. Previously,
we simply had a webmail client on the server; the problem was, nobody ever checked it.
Now, with a little help from a Mailin daemon, emails are posted to the server and readily
accessible and can be replied to directly from the admin panel. Users can also now
easily be added by entering their email in the admin panel. A message is sent to them
with a one-time use token for signup, and they can use that to join and fill in all their
own information. User's may now also be disabled, which we've learned can be important...


### Contribution

_Contribution is open to UNT students looking to build their GitHub
profile. If you want to contribute, but don't know where to start,
email me at notCaseyWebb@gmail.com_
