interface TestimonialContent {
  author: string;
  twitter: string;
  title: string;
  photoUrl: string;
  message: string;
}

export const testimonials: TestimonialContent[] = [
  {
    author: 'Remi Rousselet',
    twitter: 'https://twitter.com/remi_rousselet',
    title:
      'Flutter enthusiast, creator of the flutter_hooks, provider packages.',
    photoUrl: require('../images/people/remi.jpg').default,
    message: "It's like BLoC, but actually works.",
  },
  {
    author: 'Sanket Sahu',
    twitter: 'https://twitter.com/sanketsahu',
    title:
      'Founder of GeekyAnts • Creator of BuilderXio, NativeBaseIO & VueNativeIO • Speaker • Loves tea • Strums guitar',
    photoUrl: require('../images/people/sanket.jpg').default,
    message:
      'We at GeekyAnts have used MobX.dart in many Flutter projects. We have chosen it as the default state-management library for the internal frameworks built for Flutter.',
  },

  {
    author: 'Chris Sells',
    twitter: 'https://twitter.com/csells',
    title:
      'Ex-Product Manager on the Flutter Development Experience. Enjoys long walks on the beach and various technologies.',
    photoUrl: require('../images/people/chris.png').default,
    message: `If you haven\'t seen MobX.dart @ https://mobx.netlify.app, check it out. In combination with Provider, it\'s PFM (Pure Flutter Magic). I use it when I build anything real. #recommended #Flutter`,
  },
  {
    author: 'Michael Bui',
    twitter: 'https://twitter.com/MaikuB84',
    title:
      'Flutter Enthusiast and maintainer of flutter_local_notifications and flutter_appauth packages.',
    photoUrl: require('../images/people/michael.jpg').default,
    message: `MobX's concepts of Observables, Actions and Reactions make it intuitive to figure out how to model the state of an application. I would highly recommend it as a solution for managing the application's state.`,
  },
  {
    author: 'Robert Felker',
    twitter: 'https://twitter.com/BlueAquilae',
    title: '#Minimalism | #flutter artist | github Awesome #flutter',
    photoUrl: require('../images/people/robert.jpg').default,
    message: `On Professional projects, MobX helps me manage hundreds of forms and thousands of fields with transparency.
When working on Generative Art, it helps me create highly configurable widgets without complexity. 
MobX supports me on all of my projects.`,
  },
  {
    author: 'Jacob Moura',
    twitter: 'https://twitter.com/jacob_moura',
    title:
      'Founded the Brazilian community Flutterando. Creator of bloc_pattern, Slidy and flutter_modular packages.',
    photoUrl: require('../images/people/jacob.jpg').default,
    message: `MobX feels so robust and leverages the Dart language very well.
Brazil's community was previously attached to BLoC. With MobX, they have found a great replacement.
Several people here in Brazil are building Flutter apps quickly, thanks to MobX.`,
  },
  {
    author: 'Aloïs Deniel',
    twitter: 'https://twitter.com/aloisdeniel',
    title:
      'Mobile app maker in ❤️ with Flutter & Figma & Firebase | @JintoApp co-founder | @FlutterRennes',
    photoUrl: require('../images/people/alois.jpg').default,
    message: `This framework is just awesome. I ported my Flutter
 app to it and everything feels so much simpler now (even if the porting process has not been easy). 
I highly recommend it ! 👌`,
  },
];
