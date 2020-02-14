# StackUsers

This is a simple small project with just one screen that shows a list of top 20 StackOverflow users.

If the server is unavailable a popup will appear and the user could press the retry button to try again the network call.

The users can be followed and blocked but closing the app the settings will be lost because of for this challenge the persistence is not required (but could be a good “future implementation”).

The download of the user image starts when the cell appear and is cancelled when the cell will disappear to avoid resource waste. 

I used MVVM without coordinators because it is just 1 screen.

I create a class Bindable to bind the view to viewModel state ( this is why the closure is on the main thread).

Just for demo reasons I decided to put all the extensions in a single file.

Since there are only 20 images I avoided to use the NSCache, but could be a good improvement with more images.

I also tested the app with network link conditioner test the app in bad connection situation.

Only unit tests was required so I avoided to make UITests. I tested only the business logic of the app, and I make a mock network to test it.


