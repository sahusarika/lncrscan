# Introduction #

This is a guide for installing lncRScan.

# OS requirement #
Unix/Linux

# Steps #

<li>Download "lncrscan" which contains three folders to your home directory <i>MY_DIR</i>.<br>
<br>
<pre><code><br>
$ svn checkout http://lncrscan.googlecode.com/svn/trunk/ lncrscan-read-only<br>
</code></pre>

<li>Set environmental variables on your OS by modifying <i>.bashrc</i>

<pre><code><br>
export PATH=$PATH:/MY_DIR/scripts<br>
export PERL5LIB=$PERL5LIB:/MY_DIR/lib<br>
</code></pre>

<li> Use the new environmental variables<br>
<pre><code><br>
$ source .bashrc<br>
</code></pre>

<li>Make all scripts executable by<br>
<br>
<pre><code><br>
$ chmod 0775 /MY_DIR/scripts/*<br>
</code></pre>