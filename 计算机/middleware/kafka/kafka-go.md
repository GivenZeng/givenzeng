## sarama
* [github](https://github.com/Shopify/sarama)
* [官网](https://shopify.github.io/sarama/)

一个golang kafka客户端。提供的高层次封装有：
* 生产消息：AsyncProducer 或者 SyncProducer。AsyncProducer使用一个通道接收消息，并且使用异步方式将消息发送到kafka。SyncProducer使用阻塞方式将消息发送到kafka
* 消费信息：Consumer。Consumer尚为提供消费者组的再平衡优化和offset追踪。

对于低层次的操作可以更加灵活，sarama提供了Broker 和 Request/Response来进行较底层的操作。本文暂不介绍底层操作。

## 写入，生产者
```
import (
  "github.com/Shopify/sarama"
  )
// 采用默认配置
config := sarama.NewConfig()
// 指定broker列表
brokers :=[]string {'localhost:5678'}
producer, err := sarama.NewAsyncProducer(brokers, config)
if err != nil {
    panic(err)
}

defer func() {
    if err := producer.Close(); err != nil {
        log.Fatalln(err)
    }
}()

// 等该结束信号
signals := make(chan os.Signal, 1)
signal.Notify(signals, os.Interrupt)

var enqueued, errors int
ProducerLoop:
for {
    select {
      //写入kafka队列，要指定：主题、key（为nil则使用默认）、消息encoder
    case producer.Input() <- &ProducerMessage{Topic: "my_topic", Key: nil, Value: StringEncoder("testing 123")}:
        fmt.Println("finish produce a message")
        enqueued++
    // 判断是否有错误    
    case err := <-producer.Errors():
        log.Println("Failed to produce message", err)
        errors++
    // 如果有结束信号    
    case <-signals:
        break ProducerLoop
    }
}
log.Printf("Enqueued: %d; errors: %d\n", enqueued, errors)
```

## 消费者
```
//
consumer, err := NewConsumer([]string{"localhost:9092"}, nil)
if err != nil {
    panic(err)
}

defer func() {
    if err := consumer.Close(); err != nil {
        log.Fatalln(err)
    }
}()

partitionConsumer, err := consumer.ConsumePartition("my_topic", 0, OffsetNewest)
if err != nil {
    panic(err)
}

defer func() {
    if err := partitionConsumer.Close(); err != nil {
        log.Fatalln(err)
    }
}()

// Trap SIGINT to trigger a shutdown.
signals := make(chan os.Signal, 1)
signal.Notify(signals, os.Interrupt)

consumed := 0
ConsumerLoop:
for {
    select {
    case msg := <-partitionConsumer.Messages():
        log.Printf("Consumed message offset %d\n", msg.Offset)
        consumed++
    case <-signals:
        break ConsumerLoop
    }
}

log.Printf("Consumed: %d\n", consumed)
```
## sarama cluster
[github](https://github.com/bsm/sarama-cluster)

sarama cluster是一个基于sarama的golang消费者库
## 消费者
* 以下的例子展示如何使用消费者使用channel从多个topic读取信息

```
// 初始化配置：是否返回错误信息、通知信息
config := cluster.NewConfig()
config.Consumer.Return.Errors = true
config.Group.Return.Notifications = true

// 初始化消费者，指定broker，消费者组，topic
brokers := []string{"127.0.0.1:9092"}
topics := []string{"my_topic", "other_topic"}
consumer, err := cluster.NewConsumer(brokers, "my-consumer-group", topics, config)
if err != nil {
    panic(err)
}
defer consumer.Close()

// 等待关闭信息，如ctrl+c
signals := make(chan os.Signal, 1)
signal.Notify(signals, os.Interrupt)

// 消费error信息
go func() {
    for err := range consumer.Errors() {
        log.Printf("Error: %s\n", err.Error())
    }
}()

// 消费 notifications 信息
go func() {
    for ntf := range consumer.Notifications() {
        log.Printf("Rebalanced: %+v\n", ntf)
    }
}()

// 消费目标信息
for {
    select {
    case msg, ok := <-consumer.Messages():
        if ok {
            fmt.Fprintf(os.Stdout, "%s/%d/%d\t%s\t%s\n", msg.Topic, msg.Partition, msg.Offset, msg.Key, msg.Value)
            consumer.MarkOffset(msg, "") // mark message as processed
        }
    case <-signals:
        return
    }
}
```
* 以下例子展示如何使用consumer从独立的分区读取数据

Code:

```
// 初始化配置 ConsumerModePartitions
config := cluster.NewConfig()
config.Group.Mode = cluster.ConsumerModePartitions

// 初始化消费者，指定broker，消费者组，topic
brokers := []string{"127.0.0.1:9092"}
topics := []string{"my_topic", "other_topic"}
consumer, err := cluster.NewConsumer(brokers, "my-consumer-group", topics, config)
if err != nil {
    panic(err)
}
defer consumer.Close()

// 等待关闭信息，如ctrl+c
signals := make(chan os.Signal, 1)
signal.Notify(signals, os.Interrupt)

// 消费分区信息
for {
    select {
    case part, ok := <-consumer.Partitions():
        if !ok {
            return
        }

        // start a separate goroutine to consume messages
        go func(pc cluster.PartitionConsumer) {
            for msg := range pc.Messages() {
                fmt.Fprintf(os.Stdout, "%s/%d/%d\t%s\t%s\n", msg.Topic, msg.Partition, msg.Offset, msg.Key, msg.Value)
                consumer.MarkOffset(msg, "") // mark message as processed
            }
        }(part)
    case <-signals:
        return
    }
}
```
