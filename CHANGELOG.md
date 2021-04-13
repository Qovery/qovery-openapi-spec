# Changelog for the API documentation.

Please add a changelog here each time you update the API documentation.

# 2021-04-13 : changes based on patryk's feedbacks

* updated commit resource to remove id and updated_at fields
* updated application log resource to remove updated_at field
* renamed "owner" field to "user" in application log
* fixed issue on GET application/id/log. There was an issue, the body response was not displayed
* updated POST application/id/event/id/rollback response to respond the application resource instead of newly created event
* added description for calls allowing to create override/alias on env variables/secrets, to explain that the response body will contain the newly created variable/secret
* removed POST database/id/application/{targetedApplicationId} that allowed to attach an app to a database. We removed that action in the web UI. User will have to go to his application settings to make the link between app and logical database. It also reduces confusion as there were a lot of calls on the app/database/logicalDatabase links. Besides, attach an app to a database is not very useful. The interesting action for the user is to attach a logicalDatabase to his app. I only let the DEL database/id/application/{targetedApplicationId}. This way the user will not have to remove each logical database one by one from the application settings, but can remove the app from the database.
* added description in GET application/id/links and GET environment/id/links
* removed request body on POST environment/id/deploy (before we were asking for commit_id, which was a copy/paste error. the call triggers the depoloyment of all apps/dbs to their latest versions)