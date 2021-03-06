package org.gotson.komga.interfaces.rest

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.security.test.context.support.WithAnonymousUser
import org.springframework.security.test.context.support.WithMockUser
import org.springframework.test.context.junit.jupiter.SpringExtension
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get
import java.nio.file.Files

@ExtendWith(SpringExtension::class)
@SpringBootTest
@AutoConfigureMockMvc(printOnlyOnFailure = false)
class FileSystemControllerTest(
    @Autowired private val mockMvc: MockMvc
) {
  private val route = "/api/v1/filesystem"

  @Test
  @WithAnonymousUser
  fun `given anonymous user when getDirectoryListing then return unauthorized`() {
    mockMvc.get(route)
        .andExpect { status { isUnauthorized } }
  }

  @Test
  @WithMockUser
  fun `given regular user when getDirectoryListing then return forbidden`() {
    mockMvc.get(route)
        .andExpect { status { isForbidden } }
  }

  @Test
  @WithMockUser(roles = ["USER", "ADMIN"])
  fun `given relative path param when getDirectoryListing then return bad request`() {
    mockMvc.get(route) {
      param("path", ".")
    }.andExpect { status { isBadRequest } }
  }

  @Test
  @WithMockUser(roles = ["USER", "ADMIN"])
  fun `given non-existent path param when getDirectoryListing then return bad request`() {
    val parent = Files.createTempDirectory(null)
    Files.delete(parent)

    mockMvc.get(route) {
      param("path", parent.toString())
    }.andExpect { status { isBadRequest } }
  }
}
