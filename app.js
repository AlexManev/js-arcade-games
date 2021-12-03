
var express = require('express');

var app = express();
var port = process.env.PORT || 3000;

app.use(express.static(__dirname + '/public'));     //serve static assets
app.get('/', function(req, res) {
    res.sendfile('./public/index.html'); // load the single view file (angular will handle the page changes on the front-end)
});

app.get('/002-cyberbreach-2021/content', function(req, res){
    res.setHeader('x-next-part', '/jelly_fish.html');
    res.json({
        info: `The main basic difference between programmer subculture and computer security hacker is their mostly separate historical origin and development. However, the Jargon File reports that considerable overlap existed for the early phreaking at the beginning of the 1970s. An article from MIT's student paper The Tech used the term hacker in this context already in 1963 in its pejorative meaning for someone messing with the phone system. The overlap quickly started to break when people joined in the activity who did it in a less responsible way. This was the case after the publication of an article exposing the activities of Draper and Engressia. According to Raymond, hackers from the programmer subculture usually work openly and use their real name, while computer security hackers prefer secretive groups and identity-concealing aliases. Also, their activities in practice are largely distinct. The former focus on creating new and improving existing infrastructure (especially the software environment they work with), while the latter primarily and strongly emphasize the general act of circumvention of security measures, with the effective use of the knowledge (which can be to report and help fixing the security bugs, or exploitation reasons) being only rather secondary. The most visible difference in these views was in the design of the MIT hackers' Incompatible Timesharing System, which deliberately did not have any security measures.
        There are some subtle overlaps, however, since basic knowledge about computer security is also common within the programmer subculture of hackers. For example, Ken Thompson noted during his 1983 Turing Award lecture that it is possible to add code to the UNIX "login" command that would accept either the intended encrypted password or a particular known password, allowing a backdoor into the system with the latter password. He named his invention the "Trojan horse". Furthermore, Thompson argued, the C compiler itself could be modified to automatically generate the rogue code, to make detecting the modification even harder. Because the compiler is itself a program generated from a compiler, the Trojan horse could also be automatically installed in a new compiler program, without any detectable modification to the source of the new compiler. However, Thompson disassociated himself strictly from the computer security hackers: "I would like to criticize the press in its handling of the 'hackers,' the 414 gang, the Dalton gang, etc. The acts performed by these kids are vandalism at best and probably trespass and theft at worst. ... I have watched kids testifying before Congress. It is clear that they are completely unaware of the seriousness of their acts."
        The programmer subculture of hackers sees secondary circumvention of security mechanisms as legitimate if it is done to get practical barriers out of the way for doing actual work. In special forms, that can even be an expression of playful cleverness. However, the systematic and primary engagement in such activities is not one of the actual interests of the programmer subculture of hackers and it does not have significance in its actual activities, either. A further difference is that, historically, members of the programmer subculture of hackers were working at academic institutions and used the computing environment there. In contrast, the prototypical computer security hacker had access exclusively to a home computer and a modem. However, since the mid-1990s, with home computers that could run Unix-like operating systems and with inexpensive internet home access being available for the first time, many people from outside of the academic world started to take part in the programmer subculture of hacking.
        Since the mid-1980s, there are some overlaps in ideas and members with the computer security hacking community. The most prominent case is Robert T. Morris, who was a user of MIT-AI, yet wrote the Morris worm. The Jargon File hence calls him "a true hacker who blundered". Nevertheless, members of the programmer subculture have a tendency to look down on and disassociate from these overlaps. They commonly refer disparagingly to people in the computer security subculture as crackers and refuse to accept any definition of hacker that encompasses such activities. The computer security hacking subculture, on the other hand, tends not to distinguish between the two subcultures as harshly, acknowledging that they have much in common including many members, political and social goals, and a love of learning about technology. They restrict the use of the term cracker to their categories of script kiddies and black hat hackers instead.
        All three subcultures have relations to hardware modifications. In the early days of network hacking, phreaks were building blue boxes and various variants. The programmer subculture of hackers has stories about several hardware hacks in its folklore, such as a mysterious "magic" switch attached to a PDP-10 computer in MIT's AI lab that, when switched off, crashed the computer. The early hobbyist hackers built their home computers themselves from construction kits. However, all these activities have died out during the 1980s when the phone network switched to digitally controlled switchboards, causing network hacking to shift to dialing remote computers with modems when pre-assembled inexpensive home computers were available and when academic institutions started to give individual mass-produced workstation computers to scientists instead of using a central timesharing system. The only kind of widespread hardware modification nowadays is case modding.
        An encounter of the programmer and the computer security hacker subculture occurred at the end of the 1980s, when a group of computer security hackers, sympathizing with the Chaos Computer Club (which disclaimed any knowledge in these activities), broke into computers of American military organizations and academic institutions. They sold data from these machines to the Soviet secret service, one of them in order to fund his drug addiction. The case was solved when Clifford Stoll, a scientist working as a system administrator, found ways to log the attacks and to trace them back (with the help of many others). 23, a German film adaption with fictional elements, shows the events from the attackers' perspective. Stoll described the case in his book The Cuckoo's Egg and in the TV documentary The KGB, the Computer, and Me from the other perspective. According to Eric S. Raymond, it "nicely illustrates the difference between 'hacker' and 'cracker'. Stoll's portrait of himself, his lady Martha, and his friends at Berkeley and on the Internet paints a marvelously vivid picture of how hackers and the people around them like to live and how they think."`
    });
});

app.listen(port, function() {
    console.log('Node server listening on port ' + port);
});