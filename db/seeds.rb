# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create({username: 'test_user', id: 99})

post = Post.create({user_id: 99, title: 'how to rails', description: 'not sure how to rails. tried everything but still cant rails. sigh.'})
Upvote.create({upvotable_id: post.id, upvotable_type: 'Post', count: 0, user_id: 99})
post = Post.create({user_id: 99, title: 'super test 9900000', description: 'this is a big fat testy mctest. nothing to see here but super fake content.'})
Upvote.create({upvotable_id: post.id, upvotable_type: 'Post', count: 0, user_id: 99})
post = Post.create({user_id: 99, title: 'best content post', description: 'Would you look at that!? this post actually has some content!!'})
Upvote.create({upvotable_id: post.id, upvotable_type: 'Post', count: 0, user_id: 99})
post = Post.create({user_id: 99, title: 'duper test 5099', description: 'super tests are lame. introducing the new and improved duper test!!!!!'})
Upvote.create({upvotable_id: post.id, upvotable_type: 'Post', count: 0, user_id: 99})
post = Post.create({user_id: 99, title: 'top 990 bars in downtown Boston', description: 'wouldnt it be awesome if I could scrape different APIs and put decent content here??'})
Upvote.create({upvotable_id: post.id, upvotable_type: 'Post', count: 0, user_id: 99})
post = Post.create({user_id: 99, title: 'Mr. Chuck Testa', description: 'I bet you thought this post was fake. Nope. Its Chuck Testa.'})
Upvote.create({upvotable_id: post.id, upvotable_type: 'Post', count: 0, user_id: 99})

