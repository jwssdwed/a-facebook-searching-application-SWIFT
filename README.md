## Facebook swift App

### Usage
Using the Json data given by FB graph APIs, this iOS app allows users to search for Facebook accounts. By using a variety of keywords or types, this application presents a set of informations from target accounts.

#### 1. homepage
This is the homepage of this app, you can input any keyword you like.
<center><img src="https://user-images.githubusercontent.com/6303340/27006841-aa9fb2a0-4df4-11e7-999e-b5baf3d1723a.jpg" width="40%">
</center>
The top-left hamburger button allows you slide this page left. In addition, the user-friendly design allows users to use fingure to slide out as well.

The slide-left function can be implemented in Navigation controller with one main page and one TableView controller.
<center><img src="https://user-images.githubusercontent.com/6303340/27006852-fd334770-4df4-11e7-8267-6746faf3e6bf.jpg" width="40%"></center>

#### 2. Result page
This is the searching result page. Since the query of this API has  several different types, I use **"Tab Bar Controller”** to give user different choices at the bottom.
<center><img src="https://user-images.githubusercontent.com/6303340/27006880-875b8052-4df5-11e7-8e52-572a8af71cf8.jpg" width="40%"></center>

The filled star means you have favorited this account already and empty refers to not. The favorites can be found in favorite page. If you click any row of the result page, you will get the detailed information of this certain account. However, due to privacy, you aren't able to access to any accounts if you don't have permit.

#### 3. Detail page
The detail page shows details of a selected account. The Facebook APIs provide two different details: albums and posts. The bottom two buttons perform those two details respectively.

<center><img src="https://user-images.githubusercontent.com/6303340/27006924-a242b632-4df6-11e7-8dd6-fc5599abbf99.jpg" width="40%"></center>

<center><img src="https://user-images.githubusercontent.com/6303340/27006921-8a6fd986-4df6-11e7-87a8-028f527e4df2.jpg" width="40%"></center>

In terms of the top-right button, if you click it, a pop-up dialog box shows from bottom. If you haven't favorited it, you can favorite it here. On the other hand, if you have, you can remove it. I also used FB SDK to enable FB features in this app. The second "Share" button will redirect you to the facebook app (if you have installed) and let you share this information.

<center><img src="https://user-images.githubusercontent.com/6303340/27006941-23678314-4df7-11e7-8fe9-e85a850b1738.jpg" width="40%"></center>

<center><img src="https://user-images.githubusercontent.com/6303340/27006940-23653b36-4df7-11e7-8b50-a7dd80f640f5.jpg" width="40%"></center>

#### 4. Favorite page
The layout of favorite page is the same as search. However, only the favorited objects are presented here. This function can be realized by using Global Variable feature in Swift, like CoreData. Obviously, you can unfavorite any account in this page by click the filled star button or see the detail information of an account by select one of rows.

<center><img src="https://user-images.githubusercontent.com/6303340/27006947-760afda8-4df7-11e7-9f1e-01005f9e51b0.jpg" width="40%"></center>

Enjoy this app, and you can see a live demonstration via:  **[Click me](https://www.youtube.com/watch?v=Wl_NOvgh9QY)**
