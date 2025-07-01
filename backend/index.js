require('dotenv').config();
const express=require('express');
const app=express();
const PORT=5001;


const {admin,db} =require('./firebaseconfig');

app.use(express.json());

app.get('/',(req,res)=>{
    res.send('Intro Page is running');
});
app.get('/places',(req,res)=>{
    res.send('Places page is running')
});
app.get('/tripplan',(req,res)=>{
    res.send('TripPlan page is running')
});

const weather=require('./Routes/weather');
app.use('/weather',weather);

const food = require('./Routes/food');
app.use('/food', food);

const flight = require('./Routes/flight');
app.use('/flight', flight);

const {getTrainData} = require('./Routes/train');
app.post('/train', getTrainData);

const hotel = require('./Routes/hotel');
app.use('/hotel', hotel);

app.post('/auth/login',async (req,res)=>{

    const{idToken}=req.body;
    try{
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        const UID = decodedToken.uid;
        const name = decodedToken.name || "NO NAME";
        const email = decodedToken.email;


        const userref = db.collection('users').doc(UID);
        const userholder = await userref.get();

        if(!userholder.exists){
            await userref.set({
                name,
                email,
                createdAt: new Date().toISOString(),
                trips:[],
                
            });
            return res.status(201).json({
            message:"User saved successfully",
            user: { UID, name, email }
        });
        }
        return res.status(200).json({
            message:"User login successful",
            user: { UID, name, email }
        })

}catch(error){
        console.log("Error in Login");
        res.status(500).json({error:"Sorry! Couldn't login"});

    }
})

app.get( '/profile/:UID', async(req,res)=>{
    const{UID}=req.params;
    try{
        const userref=db.collection('users').doc(UID);
        const userholder= await userref.get();

        if(!userholder.exists){
            return res.status(404).json({
                error:"User not found",
            })
        }

        res.status(200).json({
            profile:userholder.data(),
        })

    }catch(error){
        console.error("Error in displaying profile", error),
        res.status(500).json({error:"Failed to display profile"})
    }
})


app.post('/save-trip',async (req,res)=>{

        console.log("POST /save-trip called");
   try{ const {UID,tripName,startDate,endDate,preferences}=req.body;

   if (!UID || !tripName || !startDate || !endDate || !preferences) {
            return res.status(400).json({ error: "Missing required trip fields" });
        }

    const newTrip=db.collection('trips').doc();
    const tripData={
            UID,
            tripName,
            startDate:new Date(startDate).toDateString(),
            endDate:new Date(endDate).toDateString(),
            createdAt:new Date(),
            preferences
    }
    await newTrip.set(tripData);


    res.status(201).json({
        message:"Trip saved successfully",
        tripId: newTrip.id,
        data:tripData,
    })
    }catch(error){
        console.log("Error in saving trip:",error);
        res.status(500).json({error:"Failed to save trip!"});
    }
})

app.patch('/customize-trip/:tripId',async (req,res)=>{
    const{tripId}=req.params;
    const customizedData=req.body;

    try{
        const tripref=db.collection('trips').doc(tripId);
        await tripref.update(customizedData);

        res.status(200).json({
        message:"Trip customized successfully",
    })

    }
    catch(error){
        console.error('Error in customizing trip: ',error)
        res.status(500).json({
            error:"Failed to customize trip",
    })
}
})

app.delete('/delete-trip/:tripId', async (req,res)=>{
    const{tripId}=req.params;
    try{
        const tripref=db.collection('trips').doc(tripId);
        await tripref.delete();

        res.status(200).json({
            message:"Trip deleted successfully",
        })
    }
    catch(error){
        console.error("Error in deleting trip:",error)
        res.status(500).json({
            error:"Failed to delete trip",
        })
    }
})

app.get('/get-trips/:UID',async (req,res)=>{
    const{UID}=req.params;

    try{
        //if(!UID){
        //    res.status(401).json({error:"UID is not found"})
        //}
        
        const tripref = db.collection('trips').where('UID','==',UID);

        const tripholder = await tripref.get();

        if (tripholder.empty){
           return res.status(404).json({error:"No trips found!"});
        }

        const trips=[];

        tripholder.forEach(doc =>{
            trips.push({
                "tripId":doc.id,...doc.data()
            });
        })

        res.status(200).json({
            message:"Trips retrieved successfully",
            trips
        })
    }

    catch(error){
        console.log("Error in showing trips:",error),
        res.status(500).json({error:"Error in showing trip"});
    }
})

app.get('/get-trip/:tripId',async (req,res)=>{
    const{tripId}=req.params;
    try{
        const tripref=db.collection('trips').doc(tripId);
        const tripholder= await tripref.get();

        if(!tripholder.exists){
            return res.status(404).json({
                error:"Trip does not exist"
            })
        }

        res.status(200).json({
            trip:tripholder.data(),
        })

    }catch(error){
        console.error("Error in displaying trip:",error)
        res.status(500).json({
            error:"Failed to display trip",
        })
    }





})




app.listen(PORT,()=>console.log(`Server started on PORT ${PORT}`))