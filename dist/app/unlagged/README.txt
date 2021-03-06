RUNNING UNLAGGED
----------------

If you've gotten this far, you've already unzipped "unlagged-2.0.zip" into your Quake III Arena folder.  It should have created a directory in that folder, and things should look like so:

C:\Program Files\Quake III Arena-+
                                 |
                                 +-baseq3
                                 +-unlagged-+
                                            |
                                            +-README.txt
                                            +-example.cfg
                                            +-unlagged-01cl.pk3
                                            +-vm-+
                                                 |
                                                 +-qagame.qvm


On a Linux system, things should look somewhat like this:

/usr/local/games/quake3-+
                        |
                        +-baseq3
                        +-unlagged-+
                                   |
                                   +-README.txt
                                   +-example.cfg
                                   +-unlagged-01cl.pk3
                                   +-vm-+
                                        |
                                        +-qagame.qvm


You're looking at "README.txt".  If your system doesn't look like one of the above, make it so. :)

The only PK3 file in the Unlagged distribution is the client PK3.  Clients connecting for the first time will have to download it (so make sure sv_allowdownload is 1), but it's only 94k.  The server game is "qagame.qvm" - but we've left it in the file system to get around the pure server check, allowing clients to connect and play without having to download it.

To start up Unlagged, do a line like the following:

quake3 +set fs_game unlagged +set dedicated 2 +set com_hunkmegs 24 +exec unlagged.cfg

Similarly, on Linux:

./q3ded +set fs_game unlagged +set dedicated 2 +set com_hunkmegs 24 +exec unlagged.cfg

where "unlagged.cfg" is a configuration file *you* set up.  Since there isn't much to configuring Unlagged, and its defaults are perfectly fine, you can use any Quake III server configuration file that you've already got.  If you've never set up a server before, take a look at a nice setup guide here:

http://www.3dgw.com/guides/q3a/

I've also included a simple example configuration in "example.cfg".



UNLAGGED FEATURES
-----------------

1) Total server-side lag compensation for hitscan weapons (machinegun, shotgun, lightning gun, railgun)
2) Compensation for Quake 3's built-in 50ms lag for every weapon (clients who opt out of full lag compensation get at least 50ms of lag correction, as in CPMA and OSP)
3) Correction (smoothing out movement) for players who "skip" because they have a bad outgoing connection
4) cl_timeNudge actually extrapolates - which means that when you use a negative value, other players still move smoothly



UNLAGGED SERVER VARIABLES
-------------------------

g_delagHitscan

The default is "1", and you probably shouldn't change it.  Setting it to "0" switches off feature #1 (outlined above), but you still get the rest.


g_smoothClients

g_smoothClients in Unlagged works a little differently.  Before, g_smoothClients would send a little extra information about every player entity over the wire, allowing clients to extrapolate 50ms of movement by setting cg_smoothClients to "1".  This would smooth out other players' movement if those other players had a bad connection.

With Unlagged, setting g_smoothClients to "1" causes the server to do skip correction itself, in a way that is compatible with the lag compensation.  (cg_smoothClients, by the way, is now undefined.)  In fact, having this set helps remove one obstacle to players getting consistent hits: the target's possibly low framerate and/or sporadic outgoing connection.  (The other half of removing those barriers is the lag compensation itself.)  The amount of processing power required is minimal, so I suggest having this set to "1" always.


g_unlaggedVersion

This is a read-only variable set to whatever version of Unlagged the server is running.  It is sent with the server info so it can be read with handy stuff like Q3Plug.


g_lightningDamage

The default is "8", the lightning gun's normal damage.  *Some* people have complained that the lightning gun is too powerful with lag compensation enabled.  It's been my observation that this is generally due to the following three reasons:

1) People aren't used to being able to actually *use* the darn thing, so when they can, they tend to overdo it.
2) People aren't used to *dodging* it, since it doesn't get used very often in Internet play.
3) The lightning gun has always been the best weapon at medium range when playing at LAN latencies.  The only other weapon that stands a chance against it is the plasma gun, but, all things considered, it's weaker.

If, in the first while after having Unlagged installed it seems people are using it too much, you *may* want to try lowering the damage, at least to wean the players from it. :)  In my opinion, that sort of thing should only be used as a last resort.  After a while - as I've seen in Ultra Freeze Tag on many servers - people settle back into more normal weapon selection behavior.



UNLAGGED CLIENT VARIABLES
-------------------------

cg_delag

If this is set to "1" (the default), your lag with all instant-hit weapons will be compensated for.  You can also set it for individual weapons.  These are the important values:

 1 - Everything
 2 - Shotgun
 4 - Machinegun
 8 - Lightning Gun
16 - Railgun

Add the values together.  For example, if you want lag compensation for just the lightning gun and the machinegun, you would set cg_delag to "12".


cg_cmdTimeNudge

Set this to the number of milliseconds you would like the server to "nudge" the time of your instant-hit attacks.  For example, if you feel that the server overcompensates for your ping, you might try setting it to 25.  That will effectively add 25ms of lag.


cg_projectileNudge

If you choose to use this feature, set this variable to your average ping on the server you're currently on.  That will advance the projectiles to the position they'll be in by the time your movement reaches the server, making them easier to dodge.

Of course, as with every other lag compensation technique, it comes with a small price: visual consistency.  Other players' projectiles will seem to be faster - though this isn't really a problem, since it'll reflect your actual window of useful action.  The projectiles will also seem to stick in parts of the map before they explode.

If you can deal with that, go for it: set it to your ping.


cl_timeNudge

In really technical terms, the client engine uses this setting to determine when to release snapshots to the client game.  If you set it negative, it releases them early.  If you set it positive, it releases them late.

In other words, negative values reduce lag, and positive values add lag.  There's a down side to reducing lag, though: prediction error.  The client has less to work with, so it has to guess about a few things.  It's usually pretty close to reality when it does guess.  Another down side is that, if you're opting out of full lag compensation (cg_delag 0), the rail trail can look completely off.

The big change in Unlagged is that, if you set cl_timeNudge to a negative number, other players will still look like they're moving smoothly.  (In vanilla Quake 3 and every other mod for it that I know of, they look jerky - like they're moving at 20 FPS while everything around them is moving your client's framerate.)  A slightly smaller change is that the value is clamped between -50 and 50.  Anything outside that range has always been meaningless.

Personally, I'll be playing with cl_timeNudge at -50 because it helps with the projectile weapons at small expense.


cg_drawBBox, cg_debugDelag

These variables are cheat-protected, and for testing only.  Setting cg_drawBBox to "1" will cause the client game to draw players' bounding boxes around them.  (A bounding box is basically the hit zone.)  Setting cg_debugDelag to "1" will cause both the client and server to spew a bunch of debug information at you when you use the railgun.

I used these features to make sure the lag compensation works *exactly* right.  You can test them yourself by loading up a map with the "/devmap" command.
