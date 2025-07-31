require('dotenv').config();
const cors = require('cors');
const express=require('express');
const app=express();
app.use(cors()); 
app.use(express.json());
const authRoutes = require('./Routes/auth');
const PORT=5001;


const {admin,db} =require('./firebaseconfig');

app.use('/auth', authRoutes);

app.get('/',(req,res)=>{
    res.send('Welcome to the app. Go to /auth/google to sign in.');
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

const trainRoute = require('./routes/train'); 
app.use('/trains', trainRoute);

const hotel = require('./Routes/hotel');
app.use('/hotel', hotel);

const recommendation = require('./Routes/recommendation');
app.use('/recommendation', recommendation);

const tripdetails = require('./Routes/tripdetails');
app.use('/tripdetails', tripdetails);

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
                
        const tripref = db.collection('trips').where('UID','==',UID);

        const tripholder = await tripref.get();

        if (tripholder.empty){
           return res.status(404).json({error:"No trips found!"});
        }

        const trips=[];

        tripholder.forEach(doc =>
            trips.push(doc.data())
        );

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
