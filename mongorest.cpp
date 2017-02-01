#include <cstdint>
#include <iostream>
#include <vector>
#include <bsoncxx/json.hpp>
#include <mongocxx/client.hpp>
#include <mongocxx/stdx.hpp>
#include <mongocxx/uri.hpp>
#include <bsoncxx/builder/basic/document.hpp>

using bsoncxx::builder::stream::close_array;
using bsoncxx::builder::stream::close_document;
using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;
using bsoncxx::builder::stream::open_array;
using bsoncxx::builder::stream::open_document;
using bsoncxx::builder::basic::kvp;
void bsonlr()
{
    bsoncxx::builder::basic::document  builder{};
    builder.append(kvp("hello", "world"));

    /*
    std::cout<<builder<<std::endl;
    
    auto query_value = document{} << "copies" << open_document << "$gt" << 100 << close_document << finalize;

    std::cout<<query_value<<std::endl;
    bsoncxx::document::value one_line = bsoncxx::builder::stream::document{} << "finalize" << "is nifty" << bsoncxx::builder::stream::finalize;
    std::cout<<one_line<<std::endl;
     */
}
int main()
{
    
    mongocxx::uri uri("mongodb://localhost:27017");
    mongocxx::client client(uri);
    mongocxx::database db = client["mydb"];
    
    mongocxx::collection coll = db["test"];
    
    mongocxx::stdx::optional<bsoncxx::document::value> maybe_result =
    coll.find_one(document{} << finalize);
    if(maybe_result) {
        // Do something with *maybe_result;
    }
}
