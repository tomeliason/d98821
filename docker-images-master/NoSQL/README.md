# Quickstart Running Oracle NoSQL on Docker
Start up KVLite in a Docker container. You must give it a name. Startup of KVLite is the default CMD of the Docker image:

        $ docker run -d --name=kvlite oracle/nosql

In a second shell, run a second Docker container to ping the kvlite store instance:

        $ docker run --rm -ti --link kvlite:store oracle/nosql \
          java -jar lib/kvstore.jar ping -host store -port 5000

Note the required use of --link for proper hostname check (actual KVLite container is named 'kvlite'; alias is 'store').

You can also use the Oracle NoSQL Command Line Interface (CLI). Start the following container (keep container 'kvlite' running):

        $ docker run --rm -ti --link kvlite:store oracle/nosql \
          java -jar lib/kvstore.jar runadmin -host store -port 5000 -store kvstore

        kv-> ping 
        Pinging components of store kvstore based upon topology sequence #14
        10 partitions and 1 storage nodes
        Time: 2015-12-11 09:26:07 UTC   Version: 12.1.3.4.7
        Shard Status: healthy:1 writable-degraded:0 read-only:0 offline:0
        Admin Status: healthy
        Zone [name=KVLite id=zn1 type=PRIMARY]   RN Status: online:1 offline:0
        Storage Node [sn1] on e91227b8b450:5000    Zone: [name=KVLite id=zn1 type=PRIMARY]    
        Status: RUNNING   Ver: 12cR1.3.4.7 2015-10-01 04:48:39 UTC  Build id: 44f8b0e7d93a
        Admin [admin1]		Status: RUNNING,MASTER
        Rep Node [rg1-rn1]	Status: RUNNING,MASTER sequenceNumber:39 haPort:5006

        kv-> put kv -key /SomeKey -value SomeValue
        Operation successful, record inserted.
        kv-> kv-> get kv -key /SomeKey
        SomeValue
        kv->

You have now Oracle NoSQL on a Docker container.

# More information
For more information on Oracle NoSQL, visit the [homepage](http://www.oracle.com/technetwork/database/database-technologies/nosqldb/overview/index.html) and the [documentation](http://docs.oracle.com/cd/NOSQL/html/index.html) for specific NoSQL instructions.

This image contains Oracle NoSQL Community Edition and OpenJDK.

# Licenses
Oracle NoSQL Community Edition is licensed under the [GNU AFFERO GENERAL PUBLIC LICENSE v3.0](http://www.oracle.com/technetwork/database/database-technologies/nosqldb/documentation/nosql-db-agpl-license-1432845.txt).

OpenJDK is licensed under the [GNU General Public License v2.0 with the Classpath Exception](http://openjdk.java.net/legal/gplv2+ce.html)

# Commercial Support on Docker Containers
Oracle NoSQL Enterprise Edition is **not** certified on Docker.

Oracle NoSQL Community Edition has **no** commercial support.

# Copyright
Copyright (c) 2015 Oracle and/or its affiliates. All rights reserved.
