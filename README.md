# Sign Language Translator 

This application is written using Swift and CoreML. This application implements real-time video capturing for translating sign languages into the English Language. Oftentimes, it is the case that there is a communication barrier between people who know English Language and people who know Sign Language. It is very difficult for a person who does not know Sign Language to communicate with one who knows it. This app helps in the translation of Sign Language to English Language using Deep Learning and performs real-time video processing where the user performs high signs which correspond to American Sign language and the ML Model then converts those signs into the English Language. The model is trained upon a dataset that contains approximately 35,000 images of hand signs containing Alphabets from A to Z, numbers from 0 to 9, and Blank (No hand sign). Both the front as well as the back camera can be used for video processing.

## Dataset 

The dataset being used in the application is trained upon approximately 35,000 images of the American Sign Language dataset with hand signs containing 37 different classes. The dataset is preprocessed and segmented along with different augmentation steps such as flip and rotation to improve its accuracy and precision. 

## Application Features 

### Home Screen 

This is the initial home screen where there is a button for starting real time video feed for translation

<img src="https://github.com/gitpushOmnik/Sign-Language-Translator/blob/main/README%20Images/IMG_2673.jpg" width="275" height="600">

### Camera Permission from the User 

The application asks for camera permission from the user 

<img src="https://github.com/gitpushOmnik/Sign-Language-Translator/blob/main/README%20Images/IMG_2675.jpg" width="275" height="600">

### Classification and Translation

After the real-time video has successfully started, the model then takes into account individual frames of the video and processes them as input to the model and in turn returns a classification of the image (hand sign) in the picture. There is also a dynamic label that keeps changing every time the model predicts a different hand sign. Users can use the front as well as the back camera for showing signs and translating them

<img src="https://github.com/gitpushOmnik/Sign-Language-Translator/blob/main/README%20Images/RPReplay_Final1678833960.gif" width="275" height="600">

<img src="https://github.com/gitpushOmnik/Sign-Language-Translator/blob/main/README%20Images/IMG_2679.jpg" width="275" height="600">

<img src="https://github.com/gitpushOmnik/Sign-Language-Translator/blob/main/README%20Images/IMG_2681.jpg" width="275" height="600">


### Libraries Used

* UIKit
* Vision
* CoreML
* AVFoundation
* WekKit
* CreateML

