# Stealth Alexa

The Stealth Alexa driver adds the ability to build Alexa voice bots via [Stealth](https://github.com/hellostealth/stealth). Alexa bots can be accessed via a wide array of Alexa-enabled products, including Amazon's own Echo devices (including those with displays).

This Stealth integration provides a way of building Alexa Skills using Stealth. Though the patterns for voice bots are the same as text-based bots, the reply types supported are unique.

## Configure the Integration

## Replies

Alexa replies are unique in that each request is processed synchronously (unlike most other Stealth integrations). Therefore, each reply should only contain a single reply.

Here are the supported replies for the Alexa integration:

### Speech

These are standard replies for Alexa Skills. They are similar to `text` replies in other integrations. They can be sent like:

```yaml
- reply_type: speech
  text: Hello World!
```

If your speech contains difficult to pronouce words or you wish to add effects to the speech, you can send along [SSML](https://developer.amazon.com/docs/custom-skills/speech-synthesis-markup-language-ssml-reference.html) to help Alexa pronouce the words.

```yaml
- reply_type: speech
  ssml: "I want to tell you a secret. <amazon:effect name="whispered">I see dead people.</amazon:effect>"
```

Optionally, you can specify a `playBehavior` for how Alexa treats your reply. More info [here](https://developer.amazon.com/docs/custom-skills/request-and-response-json-reference.html#outputspeech-object).

```yaml
- reply_type: speech
  text: Hello World!
  play_behavior: 'ENQUEUE'
```

### Reprompts

Reprompts are sent to the user when either they fail to respond or their response did not match one of your mapped intents. Reprompts are optional and if one is not set, nothing is sent to the user.

If you set `reprompt: true`, Stealth will re-send your speech.

```yaml
- reply_type: speech
  text: Hello World!
  reprompt: true
```

You may also customize your reprompt by specifying a complete `speech` object:

```yaml
- reply_type: speech
  text: "Today will provide you a new learning opportunity. Stick with it and the possibilities will be endless. Can I help you with anything else?"
  reprompt:
    text: "Can I help you with anything else?"
```

You can also specify an SSML reprompt.

### Cards

Cards are rich media that can be displayed via the Alexa mobile app or on devices that may feature a screen. Stealth supports all four card types:

* Simple - a card that contain a title and plain text content
* Standard - a card that contain a title, plain text content, and an image
* LinkAccount - a card that displays a link to an authorization URI that the user can use to link their Alexa account with a user in another system. See [Account Linking for Custom Skills](https://developer.amazon.com/docs/account-linking/account-linking-for-custom-skills.html) for details.
* AskForPermissionsConsent - A card that asks the customer for consent to obtain specific customer information, such as Alexa lists or address information. See [Alexa Shopping and To-Do Lists](https://developer.amazon.com/docs/custom-skills/access-the-alexa-shopping-and-to-do-lists.html#missing_permissions) and [Enhance Your Skill with Address Information](https://developer.amazon.com/docs/custom-skills/device-address-api.html).


Simple card:

```yaml
- reply_type: card
  type: Simple
  title: Hello World
  content: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas pretium, sem sed placerat elementum, purus quam iaculis dolor, a euismod urna magna et sem.
```

For standard cards, you can specify a large and small image. For more info on the dimensions and file format, please check out [Alexa's documentation](https://developer.amazon.com/docs/custom-skills/include-a-card-in-your-skills-response.html#image_size).

```yaml
- reply_type: card
  type: Standard
  title: Hello World
  content: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas pretium, sem sed placerat elementum, purus quam iaculis dolor, a euismod urna magna et sem.
  small_image_url: https://loremflickr.com/720/480
  large_image_url: https://loremflickr.com/1200/800
```

### Sessions

By default, Stealth will keep a session open between replies. If you would like to end a session, you can set the `end_session` key to any reply:

```yaml
- reply_type: speech
  text: Hello World!
  end_session: true
```

### Session Attributes

While your user's session is active, you can pass along key-value pairs in your responses. These will be spent back by Alexa in their requests. This is useful for multi-step scripts, like for example ordering a pizza.

To set these session values, you can include the `session_values` key in any your responses (except `AudioPlayer` and `PlaybackController` replies).

```yaml
- reply_type: speech
  text: Hello World!
  session_values:
    x: 1
    y: blue
```

### Directives

Coming soon.

### Delays

Delays are not supported for Alexa bots.
