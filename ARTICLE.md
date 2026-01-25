# The story how I built this app
## Motivation
I want to vibecode a backend and frontend for some well-known persistent package in IRIS
I decided to build the UI for [samples BI demo](https://openexchange.intersystems.com/package/samples-bi-demo) - it has a bunch of persistent classes with some data, it is a good example of an IRIS backend with data samples. As soon as it can be installed with IPM, I'd just proceed with:
```
zpm "install samples-bi-demo"
```
## 
My vibecoding setup includes VS-Code with installed ObjectScript plugins and a Codex plugin from OpenAI, also a template for IRIS as a repo (I used the very basic ObjectScript template from Open Exchange.

So've installed samples-bi-demo and made sure it works smoothly in IRIS BI: here is the screenshot (installed dsw also for better UI):

The recipe of the UI I'll follow in this example is simple as follows: there will be frontend communicating via REST API represented by a particular swagger API that is implemented in IRIS.

So, let's have a swagger API? 
IRIS 2025.3 supports swagger 2.0 API, so I'd just ask Codex to generate a necessary swagger API for CRUD operations vs persistent class.
We'd need AI to deal with the source code of persistent classes so I exported them from local IRIS server:


So we have Product, Outlet, Country, Region and Transaction.
I think we'd need a page that will allow to maintain Products - create and edit them.
Let's build the spec to help with this. I asked codex to create a spec.cls, also make Product derived from %JSON.Adaptor to ease the implementation. And, what is necessary, I also asked Codex to follow the instructions in AGENTS.md file that contains the "wisdom" of my previous interactions with him. I decided to name the app as /holefoods/api.
It generated the class Holefoods.api.spec (I asked for the name) and once it got compiled another two classes appeared on a server: Holefoods.api.disp and Holefoods.api.impl. disp one is generated and maintains the map of endpoints and standard in/out procedures with requests and responses, and impl will contain the exact implementation.
Knowing me, Codex asked whether I want to proceed and add the web api into module.xml so it gets created when IRIS starts and also what is the name of disp class - so I shared with him and asked for that.
There also a lot of hoops and hurdles sometimes just to make IRIS Web app work in a secure environment, so I asked Codex to create a related Holefoods.api.security.cls that introduces necessary adjustments to make the API responsive and secure.

Then I asked Codex to make an implementation in impl class - and it did!

With this we can restart IRIS and see if we the API working - this we can test e.g. with swagger-ui module:
zpm "install swagger-ui"

To make swagger-ui work make sure you have _spec endpoint and its implementation in impl (always same).
Here is the API i got:

And you can test it out - here is what I'm getting for /holefoods/api/products GET request:

After testing the UI we can build and connect the frontend to the api. We can ask codex to do it or go to loveble and ask it to build the UI vs the spec. 

Here is what I've got locally made by Codex - it suggested Vite+TS React and I agreed :
Image

The UI can be reached at: http://localhost:5174/

After testing the UI and maybe fixing some potential issues (in my case deletion didn't work) let's introduce another important element - unittests for the API.
I've just asked Codex to introduce a unittest class HoleFoods.api.Unittests.cls that will cover all the endpoints in spec. And it did.
I've also introduced it into the module so it gets convenient to run the tests as:
zpm "test esh-vibe-back-demo"

and see results in a unit-test portal:


I also asked Codex to add /transactions endpoint and build a UI to show some sales on products by years and months. Here is the result:


## Conclusion


