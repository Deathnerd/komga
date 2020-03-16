package org.gotson.komga.domain.model

import net.greypanther.natsort.CaseInsensitiveSimpleNaturalComparator
import org.hibernate.annotations.Cache
import org.hibernate.annotations.CacheConcurrencyStrategy
import org.hibernate.annotations.Type
import java.util.*
import javax.persistence.Cacheable
import javax.persistence.CollectionTable
import javax.persistence.Column
import javax.persistence.ElementCollection
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.Lob
import javax.persistence.OrderColumn
import javax.persistence.Table

private val natSortComparator: Comparator<String> = CaseInsensitiveSimpleNaturalComparator.getInstance()

@Entity
@Table(name = "media")
@Cacheable
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE, region = "cache.media")
class Media(
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    var status: Status = Status.UNKNOWN,

    @Column(name = "media_type")
    var mediaType: String? = null,

    @Column(name = "thumbnail")
    @Lob
    @Type(type = "org.hibernate.type.BinaryType")
    var thumbnail: ByteArray? = null,

    pages: Iterable<BookPage> = emptyList(),

    @Column(name = "comment")
    var comment: String? = null
) : AuditableEntity() {
  @Id
  @GeneratedValue
  @Column(name = "id", nullable = false, unique = true)
  val id: Long = 0

  @ElementCollection(fetch = FetchType.LAZY)
  @CollectionTable(name = "media_page", joinColumns = [JoinColumn(name = "media_id")])
  @OrderColumn(name = "number")
  @Cache(usage = CacheConcurrencyStrategy.READ_WRITE, region = "cache.media.collection.pages")
  private var _pages: MutableList<BookPage> = mutableListOf()

  var pages: List<BookPage>
    get() = _pages.toList()
    set(value) {
      _pages.clear()
      _pages.addAll(value.sortedWith(compareBy(natSortComparator) { it.fileName }))
    }


  fun reset() {
    status = Status.UNKNOWN
    mediaType = null
    thumbnail = null
    comment = null
    _pages.clear()
  }

  init {
    this.pages = pages.toList()
  }

  enum class Status {
    UNKNOWN, ERROR, READY, UNSUPPORTED
  }

}
