const {ApolloServer , gql} = require('apollo-server-express');
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require("dotenv");

const typeDefs = require('./schema/schema');
const resolvers = require('./resolvers/resolver')

dotenv.config();
const mongoDataMethods = require('./data/db')

const MY_PORT = process.env.PORT;
const DB_HOST = process.env.DB_HOST;

//connect to mongoDB

    const connectDB = async () => {
        try {
            await mongoose.connect(DB_HOST, {
                useNewUrlParser: true, useUnifiedTopology: true 
            })
            console.log('Mongo DB connected !');
        } catch (error) {
            console.log(error.message);
            process.exit(1)
        }
    }


async function startServer() {

    const app = express();
    const server = new ApolloServer({
        typeDefs,
        resolvers,
        context : () => ({mongoDataMethods})
    });
    await server.start();
    server.applyMiddleware({ app });
    app.listen({ port: MY_PORT }, () =>
        console.log(`🚀 Server ready at http://localhost:${MY_PORT}${server.graphqlPath}`)
    );
    return { server, app };

}
connectDB();
startServer();
