<?php
 //loadRSS.php

/* 
**
**This file will load all the latest stories from the list of rss feeeds (listed below), 
**
**
*/
//simple.php is the all-in-one php file for simplepie, a tool that parses rss feeds
require 'include\simple.php';

include 'inc_0700\credentials_inc.php';

 
$feed = new SimplePie(); 

//sets the list of rss feeds, add as many as you want
$feed->set_feed_url(array(
    
    'http://www.gizmodo.com/rss',
    'http://kotaku.com/vip.xml'
    ));
//enables caching
$feed->enable_cache(true);
//sets cache location
$feed->set_cache_location('cache');
//sets how long the cache is good for in seconds
$feed->set_cache_duration(600);
//initializes feed
$feed->init();

//this method call is to ensure thhat the feed handles the various types of content data properly
 $feed->handle_content_type();

// default starting item
$start = 0;
 
// default number of items to display. 0 = all
$length = 10; 



/*
configure mysql parameters here
*/
$TABLENAME='';

$COLUMN1='';
$COLUMN2='';
$COLUMN3='';
$COlUMN4='';

$VALUE1='';
$VALUE2='';
$VALUE3='';
$VALUE4='';
$iConn = @mysqli_connect(DB_HOST,DB_USER,DB_PASSWORD,DB_NAME) or die(myerror(__FILE__,__LINE__,mysqli_connect_error())) ;

//$sql = "'INSERT INTO ' . $TABLENAME . '(' . $COLUMN1 . ', ' . $COLUMN2 . ',' . $COLUMN3 . ') VALUES(' . $VALUE1. ',' .  $VALUE2 . ',' .  $VALUE3 .');'" ;




/*
---------------- END CONFIG AREA ---------------------

*/



// if single item, set start to item number and length to 1
if(isset($_GET['item']))
{
        $start = $_GET['item'];
        $length = 1;
}
 
// set item link to script uri
$link = $_SERVER['REQUEST_URI'];
 







// loop through items
foreach($feed->get_items($start,$length) as $key=>$item)
{
 

 
        // set query string to item number
        $queryString = '?item=' . $key;
 

 /*
        // These echo statements show how to access the data in the $item object we have, we can use these to get the data we need to store in the database.
        // we will have to use mysqli to store the data instead of using echo
    
        echo '<a href="' . $link . $queryString . '">' . $item->get_title() . '</a>';
    
        echo ' <small>'.$item->get_date().'</small><br>';
    
        echo ' title is:' . $item->get_title() .'<br>';
        echo 'permalink is ' . $item->get_permalink().'<br>';
        echo ' key is ' . $key.'<br>';
        echo 'descrption is '. $item->get_description().'<br>';
     
    
    
        echo'<pre>';
        var_dump($item->get_categories()); 
        echo'</pre>';
 
        // if single item, display content
        if(isset($_GET['item']))
        {
                echo ' <small>'.$item->get_content().'</small><br>';
        }
        echo '<br>';
}
*/
    

        $VALUE1 = $item->get_title();
        $VALUE2 = $item->get_description();
        $VALUE3 = $item->get_permalink();
        $VALUE4 = $item->get_date();
        echo $VALUE1 . $VALUE2 . $VALUE3 . $VALUE4;
        $sql = "'INSERT INTO ' . $TABLENAME . '(' . $COLUMN1 . ', ' . $COLUMN2 . ',' . $COLUMN3 . ') VALUES(' . $VALUE1. ',' .  $VALUE2 . ',' .  $VALUE3 .');'" ;

    //Tries to insert data into database
    if (mysqli_query($iConn, $sql)) 
    {
        echo "New record created successfully";
    }    
    else {
        echo "Error: " . $sql . "<br>" . mysqli_error($iConn);
    }
        
    
}
    
 
?>
