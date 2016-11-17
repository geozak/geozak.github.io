---
layout: post
title: "Quick Code: Using Bootstrap toggleable tabs and markdown interpretation"
date: 2016-11-02 23:55:00
category: quick-code
tags: html bootstrap markdown jekyll
description: Code to use Bootstrap's togglable tabs and have content interpreted as markdown.
---

{{ page.description }}

## The Code

{% highlight html linenos %}
<div class="panel panel-default">

<!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active">
      <a href="#tab-1-id" aria-controls="tab-1-id" role="tab" data-toggle="tab">
                Tab 1 Name
            </a>
        </li>
        <li role="presentation">
            <a href="#tab-2-id" aria-controls="tab-2-id" role="tab" data-toggle="tab">
                Tab 2 Name
            </a>
        </li>
        <li role="presentation">
            <a href="#tab-n-id" aria-controls="tab-n-id" role="tab" data-toggle="tab">
                Tab N Name
            </a>
        </li>
    </ul>

<!-- Tab panes -->
    <div class="tab-content">
        <div role="tabpanel" class="tab-pane active" id="tab-1-id">
            <div class="container-fluid" markdown="1">    
### Tab 1 Content
```
echo "Here is some code.";
```
</div> <!-- This close tag must be left aligned. -->
        </div>
        <div role="tabpanel" class="tab-pane" id="tab-2-id">
            <div class="container-fluid" markdown="1">
### Tab 2 Content

|---
| Default aligned | Left aligned | Center aligned | Right aligned
|-|:-|:-:|-:
| First body part | Second cell | Third cell | fourth cell
| Second line |foo | **strong** | baz
| Third line |quux | baz | bar
|---
| Second body
| 2 line
|===
| Footer row

</div> <!-- This close tag must be left aligned. -->
        </div>
        <div role="tabpanel" class="tab-pane" id="tab-n-id">
            <div class="container-fluid" markdown="1">
### Tab N Content
1. Here
2. is
    * a
    * list

</div> <!-- This close tag must be left aligned. --> 
        </div> 
    </div>
</div>
{% endhighlight %}

## The output

<div class="panel panel-default">

<!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active"><a href="#tab-1-id" aria-controls="tab-1-id" role="tab" data-toggle="tab">Tab 1 Name</a></li>
        <li role="presentation"><a href="#tab-2-id" aria-controls="tab-2-id" role="tab" data-toggle="tab">Tab 2 Name</a></li>
        <li role="presentation"><a href="#tab-n-id" aria-controls="tab-n-id" role="tab" data-toggle="tab">Tab N Name</a></li>
    </ul>

<!-- Tab panes -->
    <div class="tab-content">
        <div role="tabpanel" class="tab-pane active" id="tab-1-id">
            <div class="container-fluid" markdown="1">    
### Tab 1 Content
```
echo "Here is some code.";
```
</div> <!-- This close tag must be left aligned. -->
        </div>
        <div role="tabpanel" class="tab-pane" id="tab-2-id">
            <div class="container-fluid" markdown="1">
### Tab 2 Content

|---
| Default aligned | Left aligned | Center aligned | Right aligned
|-|:-|:-:|-:
| First body part | Second cell | Third cell | fourth cell
| Second line |foo | **strong** | baz
| Third line |quux | baz | bar
|---
| Second body
| 2 line
|===
| Footer row

</div> <!-- This close tag must be left aligned. -->
        </div>
        <div role="tabpanel" class="tab-pane" id="tab-n-id">
            <div class="container-fluid" markdown="1">
### Tab N Content
1. Here
2. is
    * a
    * list

</div> <!-- This close tag must be left aligned. --> 
        </div> 
    </div>
</div>

## Notes

For each tab there are 3 location for the tab id.
For tab 1, 2 times on line 6 and once on line 24.
For tab 2, 2 times on line 11 and once on line 32.
For tab N, 2 times on line 16 and once on line 50.

On lines 25, 33, and 51 the container-fluid divs provide spacing on the sides for the content.

The attribute markdown="1" on lines 25, 33, and 51 is what allows the content within the div block to be interpreted as markdown.
The closing tags for these divs (lines 30, 48, and 58) must be left aligned for kramdown to stop interpreting as markdown and close the block.

## Sources
[Bootstrap Togglable Tabs](http://getbootstrap.com/javascript/#tabs)
[Kramdown HTML Blocks](http://kramdown.gettalong.org/syntax.html#html-blocks)
[Kramdown Tables](http://kramdown.gettalong.org/syntax.html#tables)