This is an attempt to create a syncretic mnemonic device combining a variety of historic and modern memory techniques
in order to produce a 'one-stop-shop' for memory training that balances complexity (and therefore time invested) with 
suitability for the kinds of memory tasks I care about.

In contrast to popular historical techniques which are usually described very simply, or competition techniques, which
require large investment for a very specific application, this tries to take the middle path.

In the next sections I discus 
    why I'm trying to train my memory,
    a brief theory of memory training,
    a brief overview of techniques that I drew from,
    the system,
    considerations that inform the final system,
    and discussion of the scripts here.


# why train memory
* The things you know, particularly what you understand deeply, is nearly always the limiting factor
* learning prevents age-linked mental decline and alzheimer's (probably)
* it's the information age after all.
* I'm bored

# Design - how the system works
## Theory - how memory works
short-term memory and long-term consolidation

things are easier to remember if they are:
* more concrete (as opposed to abstract)
* related to other things you know
* suprising/funny/alarming/sexy / disgusting / rage inducing
* personally important

spaced repetition helps store things in long term memory. [Anki](https://apps.ankiweb.net/) is a very powerful tool for this.
In other words cramming doesn't work very well, especially if you want to remember it after the test.

multimodal exposure
* provides a richer experience
* transforming data from one modality to another forces close attention

# data types
* sequential
* branching
* collections

# modifiers
* complete, incomplete, append-only, modifiable
* depth
* ordered vs unordered access
* durability / permanence
* context sensitivity, time-relevance

# special structures
the brain appears to have specialized structures responsible for remembering specific types of information.
these can be co-opted to produce stronger imprints
* emotion
* faces
* locations
* smells

## Source Techniques
Fundamental to all memory techniques is the encoding of abstract information in concrete symbolism.

The Memory Palace is a common metaphor which places objects (ideas made concrete) in a physical place with the appropriate structure.
* ordered items are placed along a path
* unordered collections are placed in a room
Once placed, mentally travelling through the space lets you 'see' the objects there as reminders.
Many other techniques build upon this metaphor.

The memory palace technique can be augmented with skipping indexes. Commonly every 5th element is associated. This
allows for faster traversal of the list. It generates a [skip list](https://en.wikipedia.org/wiki/Skip_list)

Another fundamental technique is grouping or clustering, which composes multiple points of data into a single object.
This helps circumvent the issue of limited short-term memory.

History walks are an application of the memory palace where distance represents time.


Person-action-object is a competition system used to memorize numbers.
It works by first memorizing a list of 100 people along with their distinct actions and objects
which are numbered 00 through 99. In this way 6 digits (2 per person, action, or object) can be clustered into a single
scene.

Mandalas are used to organize topical knowledge around a theme. Typically the central theme is placed centrally,
with related knowledge around it in a circle.

## The system
The core is PAO, with special consideration towards the selection of people so that they may also provide anchors
for extended topics.

topics
* preservation of knowledge
* health
    * preventing illness
    * preventing injury
* sociopolitical culture
    * history
    * political/economic/conflict theory
* intellectual culture
    * philosophy
    * religion
    * math
    * computing
* art culture
    * visual art
    * music
    * sculpture
* material culture
    * physical sciences
        * chemistry
        * physics
    * practical arts
        * water/waste management
        * architecture
    * materials
        * fiber
        * metal
        * clay
        * wood
        * glass
        * bacteria
        * fire/energy

Select 100 people, actions, and objects with the following criteria
* ideally there should be lots of information available about them.
    * portraits, personal writings, video, stories, etc., accurate dates
    * for this reason real people are probably more effective
* technical or artistic accomplishment means they can be used as a center for topical mandalas.
* order by birth date
* distinct historical context lets their life story provide historical anchor
    * while primarily I'm selecting people who are distinctive and influential in areas I care about, I'm also giving 
        some consideration towards a representative mix, so I'm tracking a few other factors to avoid a monoculture.
        * gender - as a boolean for simplicity of notation, not accuracy
        * region - where they lived, not necessarily where they were born or died
            * north - north america
            * south - south america
            * east - asia/india
            * west - western europe
            * central - eastern europe/middle east
            * africa - sub-saharan africa
            * island - pacific islands/australia/carribean
        * language - whatever they spoke/wrote primarily
    
Start collecting Memory Palaces
* paths
* rooms (order locations in the room so it can be used as a list or a set)
* grid



# Mechanics - how the system is represented by the computer
I do not want to the mnemonic device to be reliant upon computers for either construction or training.
I think it important to keep the method workable by hand, even if a computer speeds things along.
To this end, the data is written by hand in a csv format that emphasizes readability and the script is deliberately
straightforward and readable.

There are two csv files.
* `person.csv` contains one row per person (totaling 100) including actions, objects, and biographic data.
* `contributions.csv` contains annotations on people categorized by a tag. a person may have more than one annotation

CSV format
* comments start with #
* the 'name' column contains the person's full canonical name in all lowercase
* dates format is 'year-month-day'
    * month and day is optional
    * BC dates have negative year
    * for example '-1000-02' indicates February in the year 1000 BC and does not specify the day
* in the interest of getting a representative worldview I'm tracking a few other factors


     
# the same but in poem form

In the pursuit of memory it is useful to have a language of symbols on which to hang data.
The power of the language is largely determined by 
    familiarity,
    it's personal meaningfulness,
    it's cognitive efficiency,
    and how well it fits the data.
    
The words of this language follow a grammar modeled after what they represent.
    Sequential data is a path.
    Sets are a room.
    Grids and trees, are a garden, with branching paths.
    
It is important to know the shape of the data to not paint yourself into a corner.
    Is all the content known from the start?
    How many items?
    Will it be remembered in order or out of order?
    How quickly and how deeply does it need to be remembered? 
        Remembering names is enough for search, if search is fast enough.
        
Pursuing the highest honors requires specialized practice.
    Do not confuse the extremes of competition for more mild practical goals.
    High return on investment is a balance of both return and investment.
    
Because of these factors, it is best to 
    Decide how much you can invest up front. A solid base is a language of 100 symbols.
    Understand cognitive efficiency and the data likely to be memorized,
    then to design a personal language that is meaningful.
    Finally, practice for familiarity.
    

# esoterica
a hundred runes filled with mana
    relate inner and outer.
Spells are writ in a line,
    a circle, a grid,
and cast out into the world.
Drink from the well.
 

# references and inspiration
Memory Craft - Lynne Kelly
The Memory Book - Harry Lorayne & Jerry Lucas

Algorithms to Live By - Brian Christian
    there is a whole subfield of computer science studying efficient data structures,
     but optimal for a computer is not necessarily optimal for a brain. Still we can take inspiration.
